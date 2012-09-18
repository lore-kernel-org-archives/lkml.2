Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2IRTIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:08:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60005 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2IRTI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:08:29 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.118.250]
In-Reply-To: <1347993165-4394-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347993165-4394-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 18 Sep 2012 22:08:08 +0300
Message-ID: <CAK=WgbZ+GYV2+EQEoteESgjZrZ3OPyQH008mA330pVeQLwu86Q@mail.gmail.com>
Subject: Re: [PATCHv3] remtoteproc: Export notification id range
To: sjur.brandeland@stericsson.com
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 9:32 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Some of the rproc drivers needs to know the range
> of the notification IDs used for notifying the device.
> Export a variable in struct rproc holding the
> largest allocated notification id.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Rebased and applied, thanks!
