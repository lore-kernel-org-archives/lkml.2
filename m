Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1ABQQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 11:16:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43239 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1ABQQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 11:16:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=aX9lLVZum4M7J2l2DPsLigHwdXtbLdYqEcxsAu8s2aRmZpUuB7jVbqdGBpjUVv51vt
         MokPDt5CZPJTutRfwR05BDlGhH+2vsVu9R8buf5hRAewQKYCNTHSlxrBFEQfOzmmHxUN
         F2W7iOOQXifZlo+VtTkREhSkzMkwrnTGRRgQQ=
Message-ID: <4D20A3D3.9070404@gmail.com>
Date: Sun, 02 Jan 2011 17:12:03 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Tim Bird <tim.bird@am.sony.com>
Subject: PRAMFS status update
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the goal of this email is to update all about the mainlining activity of
pramfs. In the last review (patch series v5) I didn't receive any
comments so maybe I can hope for the next merge window. Meanwhile I
fixed something and added support for others, here a list:

- added support for fallocate
- added support for splice
- added ioctl operations for inode flags management
- improved allocation strategy in direct io path
- fixed the return value management of pram_iget function

I created a git repo for the code:

git clone git://pramfs.git.sourceforge.net/gitroot/pramfs/pramfs

Regards,

Marco
