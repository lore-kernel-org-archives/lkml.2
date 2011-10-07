Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1JGO7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 10:59:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab1JGO7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 10:59:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=rpNoLQIW8BnAHoQFUi9xNeEb7XsYuSsbw1BdnZRricdpH07V/OJWvzA+lcyiPHocg
	NjefQk+Io4J6sdjfiJTiA==
MIME-Version: 1.0
In-Reply-To: <20111007070504.3d5cc1f5@jbarnes-e6510>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
 <20111007123133.GD1512@8bytes.org> <20111007070504.3d5cc1f5@jbarnes-e6510>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Oct 2011 08:59:12 -0600
Message-ID: <CAErSpo5Z39_sSF16PxWf_KKxB7UO9i9ZFxD9tcse1029DZEAPQ@mail.gmail.com>
Subject: Re: [PATCH 0/4 v2] PCI: Add support for PASID capability
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 8:05 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Fri, 7 Oct 2011 14:31:33 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
>
>> On Tue, Sep 27, 2011 at 03:57:12PM +0200, Joerg Roedel wrote:
>> > Hi,
>> >
>> > here is the second version of the patch-set implementing support
>> > for the PRI and PASID capabilities into the Linux kernel.  These
>> > capabilities of a PCIe device are tightly coupled with ATS, but not
>> > with IOV. So these patches start by moving the ATS code into its
>> > own file: ats.c.
>> >
>> > Support for the other two capabilities is based on that change.
>
> I've got this one queued up, but would definitely appreciate some
> reviewed-bys on it.

For patches 1-4:

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
