Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab0FAVcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:32:51 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:53955 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab0FAVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:32:47 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,342,1272844800"; 
   d="scan'208";a="205661310"
From: Tom Lyon <pugs@lyon-about.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Date: Tue, 1 Jun 2010 14:29:28 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com> <20100531181735.6bb71a5c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100531181735.6bb71a5c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006011429.28853.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 May 2010 10:17:35 am Alan Cox wrote:
> 
> Does look like it needs a locking audit, some memory and error checks
> reviewing and some further review of the ioctl security and
> overflows/trusted values.
Yes. Thanks for the detailed look.
> 
> Rather a nice way of attacking the user space PCI problem.
And thanks for that!

