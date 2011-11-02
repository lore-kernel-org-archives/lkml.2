Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1KBRBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:01:20 -0400
Received: from nm35-vm7.bullet.mail.bf1.yahoo.com ([72.30.238.79]:45364 "HELO
	nm35-vm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932609Ab1KBRBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:01:16 -0400
X-Yahoo-Newman-Id: 639651.67283.bm@smtp220.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iJikzLAVM1ka.0zv9O4uQMa5a13epX.Qq8VT1x7b7BB_AYU
 PvM8GjlQOAdNoFIsLTWLNNUhEqtPLy366QQ__JNwD9kXxJvY3kuMzqYljMcE
 6.BmzPzxrUys.KKN6OR_DXI.LLNJUqPhRNCxaKzlU.G2RTZOFaTogIt9i0ST
 CB2e6jEvaBgTlyYRRx5rGBYzwEYOZ7Y8Wvr_07610N4rRwA3yBfb_RsEH06U
 hLbuUsuALtSt7a71we6PQetVf.bStmXUKkm1wh2rHeMfxax_4Og_nT5u4k9z
 70X2fSj2_yNsB0nN3Zrw3CItjq8DKnEOvZmjoFIy5YkHqaY4vvrjKtRBBTgG
 VeNIwX5PBVKTEp1WfSB6ZypNOV6ws.bqo0KH9btXHEA3naxONhiPjTGJgoLN
 RVu9JZuVXECNYskAfHJdml0UWdg--
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Wed, 2 Nov 2011 12:01:00 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        tj@kernel.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111102170058.GA2388@zeus>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102163109.GA29430@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 09:31:09AM -0700, Dmitry Torokhov wrote:
> 
> OK, it looks like you do have input, what you do not have is X
> functioning.

The extent of my tests on input were to notice that the LED for caps
lock does not toggle when pressing "caps lock" after a bad resume. I
have also tried to blindly type "reboot" and such in what should be an
active xterm.

~ Andy
