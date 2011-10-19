Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1JSKUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 06:20:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55815 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1JSKUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 06:20:45 -0400
MIME-Version: 1.0
Date: Wed, 19 Oct 2011 14:20:44 +0400
Message-ID: <CAEUiM9MB5VRwoG5-Ay6m0Z5RhtfhbO6w4zteaUj5KpautY5HiQ@mail.gmail.com>
Subject: Writing CD/DVD on devices opened for read-only. Is it bad?
From: Igor Zhbanov <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have a question about permissions needed for CD/DVD writing.
As I see in source code user must have capability CAP_SYS_RAWIO for
CD/DVD writing
in 2.6 kernels (I'm not sure that it is needed for all types of disk writing),
but (it seems that) kernel ignores device file permissions. So you can
open /dev/cdrom
for read-only and use IOCTLs for blanking disks and CD/DVD writing.

I think that f_mode for device file should be checked. Isn't it bad to
permit "writable" IOCTLs
for devices opened read-only?

Thanks.
