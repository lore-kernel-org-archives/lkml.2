Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1LJHGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 02:06:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45831 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1LJHGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 02:06:13 -0500
MIME-Version: 1.0
In-Reply-To: <4EE2E9BB.8060801@gmail.com>
References: <4EE2E9BB.8060801@gmail.com>
Date: Sat, 10 Dec 2011 07:06:12 +0000
Message-ID: <CAPM=9tzVxGbsE4+EgTd0apvGBCUcvtnjSH-ydbr-MOVSTf1QaQ@mail.gmail.com>
Subject: Re: DRM nouveau crash with 3.2.0-rc5
From: Dave Airlie <airlied@gmail.com>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Skeggs <skeggsb@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Ben.

On Sat, Dec 10, 2011 at 5:10 AM, Berck E. Nash <flyboy@gmail.com> wrote:
> Fairly sure this is a regression since 3.1.  Watching video with mplayer
> when it occurred.  The crash locked up mplayer, and made X.org mostly
> unresponsive.  I went ahead and included the whole dmesg in case it's of
> use, the crash is at the end. Please cc as I'm not subscribed.
>
> Berck Nash
