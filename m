Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab1LYSCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 13:02:13 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56935 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1LYSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 13:02:11 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: ayanamireihz@gmail.com
Date: Sun, 25 Dec 2011 10:02:10 -0800
X-Google-Sender-Auth: Whu2jIfK38GHdKJ_D6bZZ41P8nk
Message-ID: <CAPerbBzU0E8DTjpKz4LrJbWV+vYvOnweo2GX4fGNNjtsfBH53g@mail.gmail.com>
Subject: [OT] Problems occured when install Linux in Windows environment
From: hz hanks <hankshz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all. I was trying to install Linux(Fedora) in Win7(64bits), using
LiveUSB Creator(3.11.6).

1) I first run LiveUSB Creator in my Win7, but it reported a error
that "Unable to get GetVolumeInformation ...". So I tried to run
LiveUSB Creator in another computer with Vista, there was no error
reported.

2)So I run LiveUSB Creator in my Vista with
Fedora-16-x86_64-Live-Desktop.iso (also tried
Fedora-16-i686-Live-Desktop.iso), and got the Live USB successfully.
Then I started my Win7 computer (with 150GB free space left for Linux)
with the USB as the priority. I successfully logged in and clicked
"install to hard drive". And then I could select keyboard and choose
"Basic Storage Devices". But after that, my installation is stopped
with the mouse showing busy (if using Fedora-16-i686-Live-Desktop.iso,
it'll report "unable to handle page request").

I would very appreciate If anyone could tell me how to fix it. Thank
you very much.
