Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2A3QDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:03:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36532 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2A3QDE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:03:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F26B7B6.2080107@lwfinger.net>
References: <1327930827-1719-1-git-send-email-standby24x7@gmail.com>
	<4F26B7B6.2080107@lwfinger.net>
Date: Tue, 31 Jan 2012 01:03:02 +0900
Message-ID: <CALLJCT1q51mBLvciEXEL88iHS2Bk5bOmTUGsxEpw+X3VDjxmhA@mail.gmail.com>
Subject: Re: [PATCH] [trivial] net: Fix typo in rtl8192de/dm.c
From: Masanari Iida <standby24x7@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wlanfae@realtek.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 12:31 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 01/30/2012 07:40 AM, Masanari Iida wrote:
>>
>> Correct spelling "disconnet" to "disconnect" in
>> drivers/net/wireless/rtlwifi/rtl8192de/dm.c
>>
>> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
>> ---
>>  drivers/net/wireless/rtlwifi/rtl8192de/dm.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>
>
> The patch is OK, but by convention, the subject should say "[PATCH] rtlwifi:
> rtl8192dm: Fix typo in dm.c". By getting rtlwifi in it, searching the git
> log is a lot easier.
>
> Larry
>
I will re-post this with correct subject.
Masanari
