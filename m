Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958Ab2D0R4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:56:15 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:33091 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760116Ab2D0R4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:56:13 -0400
MIME-Version: 1.0
In-Reply-To: <1335529693-14280-1-git-send-email-rnayak@ti.com>
References: <1335529693-14280-1-git-send-email-rnayak@ti.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 27 Apr 2012 10:55:50 -0700
Message-ID: <CAJOA=zNzkOvzdFSuSzC015ELZWE+Jtj=H5P9fbQSHW3HZdsZow@mail.gmail.com>
Subject: Re: [PATCH] clk: constify parent name arrays in macros
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3RHuKiR023702

On Fri, Apr 27, 2012 at 5:28 AM, Rajendra Nayak <rnayak@ti.com> wrote:
> parent name array is now expected to be const char *, make
> the relevent changes in the clk macros which define
> default clock types.
>
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>

Good catch Rajendra.  I'll pull it into clk-next.

Regards,
Mike

> ---
>  include/linux/clk-private.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index eeae7a3..6ebec83 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -70,7 +70,7 @@ struct clk {
>  #define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,            \
>                                _fixed_rate_flags)              \
>        static struct clk _name;                                \
> -       static char *_name##_parent_names[] = {};               \
> +       static const char *_name##_parent_names[] = {};         \
>        static struct clk_fixed_rate _name##_hw = {             \
>                .hw = {                                         \
>                        .clk = &_name,                          \
> @@ -85,7 +85,7 @@ struct clk {
>                                _flags, _reg, _bit_idx,         \
>                                _gate_flags, _lock)             \
>        static struct clk _name;                                \
> -       static char *_name##_parent_names[] = {                 \
> +       static const char *_name##_parent_names[] = {           \
>                _parent_name,                                   \
>        };                                                      \
>        static struct clk *_name##_parents[] = {                \
> @@ -107,7 +107,7 @@ struct clk {
>                                _flags, _reg, _shift, _width,   \
>                                _divider_flags, _lock)          \
>        static struct clk _name;                                \
> -       static char *_name##_parent_names[] = {                 \
> +       static const char *_name##_parent_names[] = {           \
>                _parent_name,                                   \
>        };                                                      \
>        static struct clk *_name##_parents[] = {                \
> --
> 1.7.1
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
