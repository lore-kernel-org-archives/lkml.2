Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2GXQ6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:58:44 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50210 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab2GXQ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <500DFC34.8070205@samsung.com>
References: <CAD=FV=XuXUe1Jyd_urCzmS5+1vv7iuNTXYr23XYZp+MnTq1HGg@mail.gmail.com>
	<1343062955-24516-1-git-send-email-dianders@chromium.org>
	<500DFC34.8070205@samsung.com>
Date: Tue, 24 Jul 2012 09:58:42 -0700
X-Google-Sender-Auth: nUfJUFCwkVRNYy7yItFCr2SkPw4
Message-ID: <CAD=FV=Wa1bCRvLNnFjhht6nvNorm3CRzX5zrn-YDA2Jec1K3Eg@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: Disable low power mode if SDIO interrupts
 are used
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Olof Johansson <olofj@chromium.org>, shashidharh@vayavyalabs.com,
        ki0351.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 6:36 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> How about using "slot" instead of "mmc"?

Done.
