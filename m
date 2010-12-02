Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab0LBOO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:14:56 -0500
Received: from blade4.isti.cnr.it ([194.119.192.20]:50910 "EHLO
	BLADE4.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab0LBOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:14:55 -0500
Date: Thu, 02 Dec 2010 15:14:28 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
In-reply-to: <20101202141134.GA22012@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, linux-lvm@redhat.com
Message-id: <4CF7A9C4.2040607@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
X-INSM-ip-source: 155.253.6.254 Auth Done
References: <4CF7A539.1050206@shiftmail.org>
 <20101202141134.GA22012@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 03:11 PM, Christoph Hellwig wrote:
> I'm pretty sure you have CONFIG_DEBUG_BLOCK_EXT_DEVT enabled.  This
> option must never be enabled, as it causes block devices to be
> randomly renumered.  Together with the ramdisk driver overloading
> the BLKFLSBUF ioctl to discard all data it guarantees you to get
> data loss like yours.
>    

Nope...

# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set


