Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1LAHkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:40:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47090 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1LAHkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:40:49 -0500
MIME-Version: 1.0
Date: Thu, 1 Dec 2011 01:40:49 -0600
Message-ID: <CABrM6wnDgRd0N5eSGffj51KR6-axAoFMNRWMZs2pFQ8dN94t0A@mail.gmail.com>
Subject: Which one corresponds to ioctl in the file_operations struct in linux/fs.h?
From: Peng Yu <pengyu.ut@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have some driver code for older version of kernel. It refers to
ioctl in the file_operations struct. But this field is change in
kernel 3.0.0-13

I find the following in linux/fs.h

1566   long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
1567   long (*compat_ioctl) (struct file *, unsigned int, unsigned long);

Does anybody know which one I should use in order to migrate the
driver code to the newer version of kernel? Thanks!

--
Regards,
Peng
