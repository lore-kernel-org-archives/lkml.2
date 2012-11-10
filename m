Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2KJIP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 03:15:29 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:45256 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2KJIP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 03:15:27 -0500
Date: Sat, 10 Nov 2012 09:15:26 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Subject: Re: [PATCH 2/3] input: stmpe-ts: Use devm_*() routines
Message-ID: <20121110081526.GA13787@order.stressinduktion.org>
Mail-Followup-To: Viresh Kumar <viresh.kumar@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	spear-devel@list.st.com
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org> <52b9fe53a8bd8dff7105209c5b1fab9da7a1510d.1352474824.git.viresh.kumar@linaro.org> <CAKohpomC1KTLk=UVim4gdYhJ5kngTZHOUvUgckD75AVH1w+FHw@mail.gmail.com> <20121110080009.GA12015@core.coreip.homeip.net> <CAKohponua2d95scdwmNsnVpG18nFYA1cuQa703kPfR7D8gF5fg@mail.gmail.com> <CAKohponupMgdMh8bvYaF+i9gRtwSJ9t4j+Gdy7mAieR8imc5Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohponupMgdMh8bvYaF+i9gRtwSJ9t4j+Gdy7mAieR8imc5Kw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 01:34:33PM +0530, Viresh Kumar wrote:
> wrapped again.. Don't know how to disable it. :(

To quote Documentation/email-clients.txt:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Gmail (Web GUI)

Does not work for sending patches.

Gmail web client converts tabs to spaces automatically.

At the same time it wraps lines every 78 chars with CRLF style line breaks
although tab2space problem can be solved with external editor.

Another problem is that Gmail will base64-encode any message that has a
non-ASCII character. That includes things like European names.

