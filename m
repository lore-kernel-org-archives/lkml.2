Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1ANKsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:48:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40722 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1ANKsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:48:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=QDma5cVqESvEn3XXke+0Qzp3blnejxjY4YHdADfci70tg2RilNDWrQKULrDszFXW1c
         WHjlNJB52hq5Z4j+cVeyQQH6pvUIChqPya0NQEm97QYJIL9P5yUp/dfkTpwJHgnNmX/q
         v+i5/JW6hY4uBuLc5j93wQ85dH7OT8b1Ev0Yc=
References: <AANLkTi=bDV52-Fc22amAEsxofL7gRC=oaU+AXgUnuRt7@mail.gmail.com> <20110114101246.GA1158@redhat.com>
In-Reply-To: <20110114101246.GA1158@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <5721A0C7-2BC4-46E7-8A55-232A827828D4@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>
X-Mailer: iPhone Mail (8C148)
From: Billy Rafferty <billy.rafferty@gmail.com>
Subject: Re: uio_pci_generic has no mapping?
Date: Fri, 14 Jan 2011 10:51:23 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Thanks for the help and the driver.

Cheers,

Billy

On 14 Jan 2011, at 10:12, "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Fri, Jan 14, 2011 at 09:52:45AM +0000, Billy Rafferty wrote:
>> Hi there,
>> 
>> I was hoping that someone might be be able to help me out using the
>> uio_pci_generic driver.
>> 
>> To gain access to the memory in the card I try to do an mmap but it
>> returns an error.
>> 
>> I was wondering if the mapping of the PCI memory regions is automatic?
>> I am not seeing /sys/class/uio/uio0/maps
>> 
>> Do I have to do something to get these to appear?
>> 
>> I would appreciate any help or pointers that you can give.
>> 
>> Regards,
>> 
>> Billy
> 
> mmap the pci resource through
> /sys/class/uio/uio0/device/resourceX
> 
> The list of resources is in
> /sys/class/uio/uio0/device/resource
> 
> -- 
> MST
