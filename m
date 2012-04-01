Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2DAR24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:28:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55531 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2DAR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:28:52 -0400
MIME-Version: 1.0
In-Reply-To: <1333301014-18692-1-git-send-email-tdent48227@gmail.com>
References: <1333301014-18692-1-git-send-email-tdent48227@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Apr 2012 10:28:30 -0700
X-Google-Sender-Auth: QBmeHm0uU_F4_qZrU3j1MOk0QiI
Message-ID: <CA+55aFx8E5DGBmhN0Mna_-BVr_TmTE_Fv2bOPNicDMxJwX7HOA@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers/media/radio: Fix build error
To: Tracey Dent <tdent48227@gmail.com>
Cc: linux-kernel@vger.kernel.org, shea@shealevy.com, mchehab@infradead.org,
        hans.verkuil@cisco.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 10:23 AM,  <tdent48227@gmail.com> wrote:
> From: Tracey <tj@tj-HP-2000-Notebook-PC.(none)>

Please fix your git config to have proper name and email (or whatever
tool you used). Your 'cc' list is similarly broken.

> Either selecting or depending on the CONFIG_SND_FM801_TEA575X_BOOL
> fixes the problem, but select seems to be more appropriate
> for the disire driver.

Doesn't work. That SND_FM801_TEA575X_BOOL has various things it
depends on, so you'd need to select them too.

So the thing is more complicated than just selecting it.

                    Linus
