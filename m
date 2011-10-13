Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1JMAYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:24:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54871 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1JMAYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:24:54 -0400
MIME-Version: 1.0
Date: Thu, 13 Oct 2011 09:24:52 +0900
Message-ID: <CAKYAXd9v_wFg2RQ_R+fYyCJnCbnuMs_VECujOen1GUSGXo3rHw@mail.gmail.com>
Subject: RFC : fat : default errors use FAT_ERRORS_CONT instead of FAT_ERRORS_RO.
From: NamJae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ogawa.

I found different error exception between linux fat and windows fat.

When fat is currputed by sudden unplug usb device formatted fat, fat
does never change RO partition on windows.

It said windows fat provide a chance that continuously access
partition except corrupted file.

Currently when access corrupted file, linux fat change RO parition
from RW. So user no longer do open/write on linux fat.

I suggest that the default errors of linux fat use FAT_ERRORS_CONT
instead of FAT_ERRORS_RO.

I want to know your opinion.

Thanks.
