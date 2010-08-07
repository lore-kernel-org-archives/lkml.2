Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0HGSid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 14:38:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63856 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab0HGSib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 14:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UdwFLPgkLjD82eBcZiET4vsAtevT6TaTZ4GrsEpnuIgopa5kk6O6gxPjPIGeM2XrA3
         x9IMRBo4F2uLvcSCt0aRcWrc/u75OmYg5d2V7s8gOyC751oZEqcMFoxy6EFZ3gNsoJfw
         84+oxiGZgnXIG1EbwoCt1iFZExFV/uhEO9yoU=
MIME-Version: 1.0
Date: Sat, 7 Aug 2010 20:38:30 +0200
Message-ID: <AANLkTimWdaBrJz-dQ3MHWwG7iZ5m1opSmLFKva880csi@mail.gmail.com>
Subject: UIO DMA to userspace question
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Tom Lyon <pugs@cisco.com>, mst@redhat.com, hjk@linutronix.de,
        gregkh@suse.de, chrisw@sous-sol.org, joro@8bytes.org, avi@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

can I use the UIO framework for the following?

The userspace portion of the driver allocates memory in user-space
using malloc() - usually resulting in a scatter pages in physical
memory.
The UIO kernel portion of the driver maps those using pci_map_sg().

Is this possible, or does the UIO framework assume memory for DMA is
allocated in kernel space?


Thanks,
-- 
Leon
