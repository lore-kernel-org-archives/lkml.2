Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1ANJxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:53:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45624 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1ANJxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:53:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=vyoG1sYKdwVGY8amwDC+vuxJmk5qwzJrw8KMBYClo69t3c0M4LqJGCXFpACZCVfQN5
         BheZM17ri1v2JbOnERDRkf1zoZZqZf6h5aR+zCi7+/yUyTq2zP/nleWkto5u5QQGr4DK
         mfNlpe4niglE+jS8hdq1Lu4+5pVZnuTHsc9Gk=
MIME-Version: 1.0
From: Billy Rafferty <billy.rafferty@gmail.com>
Date: Fri, 14 Jan 2011 09:52:45 +0000
Message-ID: <AANLkTi=bDV52-Fc22amAEsxofL7gRC=oaU+AXgUnuRt7@mail.gmail.com>
Subject: uio_pci_generic has no mapping?
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, hjk@hansjkoch.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I was hoping that someone might be be able to help me out using the
uio_pci_generic driver.

To gain access to the memory in the card I try to do an mmap but it
returns an error.

I was wondering if the mapping of the PCI memory regions is automatic?
 I am not seeing /sys/class/uio/uio0/maps

Do I have to do something to get these to appear?

I would appreciate any help or pointers that you can give.

Regards,

Billy
