Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1KUVK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:10:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39435 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1KUVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:10:20 -0500
MIME-Version: 1.0
In-Reply-To: <20111121205230.GA14467@srcf.ucam.org>
References: <1321908536-5163-1-git-send-email-seth.forshee@canonical.com>
	<20111121205230.GA14467@srcf.ucam.org>
Date: Mon, 21 Nov 2011 22:10:18 +0100
Message-ID: <CAHR064h0=tmY6-=PCHKfOa=w_38yVzGoV1XSCNDGimzjn7vydQ@mail.gmail.com>
Subject: Re: [PATCH] dell-wmi: Change debug statements from pr_info to pr_debug
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 9:52 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> They're intended to be there, in the same way that the keyboard code
> generates unknown scancode errors. We want to know when users have keys
> that don't work.

Agree, and if specific known key should be ignored, they should be
present in the keymap.

-- 
Corentin Chary
http://xf.iksaif.net
