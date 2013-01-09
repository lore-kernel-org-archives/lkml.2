Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3AIL1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:27:25 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49142 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab3AIL1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:27:24 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130108143710.GA16343@fieldses.org>
References: <20130103204624.GA2533@fieldses.org>
	<CA+5PVA6PSsWGVAvSkdZXgoPaaroTuC0LvJ6-3mo1aU9LEUA1Sw@mail.gmail.com>
	<20130103231123.GD3238@fieldses.org>
	<20130106180652.GQ5737@phenom.ffwll.local>
	<20130108143710.GA16343@fieldses.org>
Date: Wed, 9 Jan 2013 12:27:22 +0100
X-Google-Sender-Auth: xlZ1TgQMBWgMTPCEpT4KHh7ldKQ
Message-ID: <CAKMK7uG-1xoc49HhCxrpgO2xgsskJ6YXo7GBHCwsgQrSuDXd4A@mail.gmail.com>
Subject: Re: "Hangcheck timer elapsed... GPU hung" in 3.8.0-rc2
From: Daniel Vetter <daniel@ffwll.ch>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 3:37 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
>> please grab the i915_error_state file from debugfs
>
> As I said in the original mail, I've already done that:
>
>         http://fieldses.org/~bfields/3.8-hang/

Sorry, missed that the first time around.

>> and file a bug on
>> bugs.freedesktop.org against DRM - DRI (Intel).
>
> Would it still be useful for me to file a bug?  (Just going through the
> new-account confirmation dance now.)

Looks like the ilk bug tracked at
https://bugs.freedesktop.org/show_bug.cgi?id=55984

-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
