Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2DIPUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:20:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51646 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab2DIPUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:20:00 -0400
MIME-Version: 1.0
Date: Mon, 9 Apr 2012 17:19:59 +0200
Message-ID: <CADDKRnALwHa=QteDDcMxBU24rfbKoTOGX=iTcfeE7=M7a+NFcw@mail.gmail.com>
Subject: [v3.4-rc] regression: reboot not working
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On reboot it shuts down as normal.
The last lines displayed are:

>.
>Unmounting temporary filesystems.. [OK]
>Deactivating swap...               [OK]
>Unmounting local filesystems...    [OK]
>Will now restart
>    Restarting system

Then I hear it accessing the cd-drive, but then
it's being stuck.

v3.3 was ok. HW is a Thinkpad T43.

Please Cc me I'm not subscribed.

Thanks,Joerg
