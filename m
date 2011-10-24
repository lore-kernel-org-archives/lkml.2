Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab1JXRE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:04:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52240 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab1JXRE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:04:26 -0400
MIME-Version: 1.0
In-Reply-To: <1319476183.3210.12.camel@lovely>
References: <op.v3q34la3dsdv5o@localhost>
	<1319476183.3210.12.camel@lovely>
Date: Mon, 24 Oct 2011 15:04:24 -0200
Message-ID: <CACGt9ynNh84DOM-vDxNCF96O4m9KQ1PKpePO6_2X_8deVZQexQ@mail.gmail.com>
Subject: Re: Linux USB HID should ignore values outside Logical
 Minimum/Maximum range
From: =?UTF-8?Q?Denilson_Figueiredo_de_S=C3=A1?= <denilsonsa@gmail.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 15:09, Christoph Fritz <chf.fritz@googlemail.com> wrote:
>
>  * Note that input core does not clamp reported values to the
>  * [minimum, maximum] limits, such task is left to userspace.

That means this is a bug in X.org, instead?

-- 
Denilson Figueiredo de Sá
Rio de Janeiro - Brasil
