Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab2GCCuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:50:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44389 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2GCCt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:49:59 -0400
X-AuditID: cbfee60c-b7fe66d0000058a5-e2-4ff25dd6f760
Date: Tue, 03 Jul 2012 02:49:58 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: spelling of detach in function doc
To: Peter Meerwald <pmeerw@pmeerw.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120703024628338@myungjoo.ham
Msgkey: 20120703024628338@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120703024628338@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7212447.96341341283796934.JavaMail.weblogic@epml05>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/tGbrXYj/5G/RdY7G4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZly+uYi34w11x5P8CxgbGC9xdjJwcQgLqEouWnGQDsSUETCS+
	H1vGAmGLSVy4t54NomY+o8SuXskuRg4OFgEViemHS0BMNgE9iZmfk0EqhAXsJS7PnsoMYosI
	ZEp0bWhgB7GZBQokXq57CzVFSWLNvldg03kFBCVOznwCtUlV4tW72YwQcTWJGUdfQ8UlJGZN
	v8AKYfNKzGh/ChWXk5j2dQ0zhC0tcX7WBkaYixd/fwwV55c4dnsHE8iZIL1P7gfDjNm9+QvU
	swISU88chGrVkmjv2AUV55NYs/AtC8yYXaeWM8P03t8ylwniLUWJKd0PoV7UkvjyYx8burd4
	BRwkDiyczzKBUW4WktQsJO2zkLQjq1nAyLKKUTS1ILmgOCk91UivODG3uDQvXS85P3cTIzjC
	n/HsYJzTYHGIUYCDUYmHly36k78Qa2JZcWXuIUYJDmYlEd64Ix/9hXhTEiurUovy44tKc1KL
	DzFKc7AoifNOtr7gLySQnliSmp2aWpBaBJNl4uCUamA0nH/1RNfMM1sFghrVe7tSl7lwnLB7
	Z/QodtGrNymPGgzWfyy55dNakRsXs8Mh65vazz/3FFrXKZY/PiN29yJ/14UqxtLqpdytP95s
	a960OzHgjqTElLPp5ye8fOL7KdPx9krrjysasg+WpDJ2/b3zLupu+WPv2Dt/nh18UHdjYW9R
	f325ds0zJZbijERDLeai4kQABzY9hOwCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q632o89S013149

> Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>

Thanks.
This patch will appear at http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next along with other extcon drivers soon.


Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

> ---
>  include/linux/extcon/extcon_gpio.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/extcon/extcon_gpio.h b/include/linux/extcon/extcon_gpio.h
> index a2129b7..2d8307f 100644
> --- a/include/linux/extcon/extcon_gpio.h
> +++ b/include/linux/extcon/extcon_gpio.h
> @@ -31,7 +31,7 @@
>   * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
>   * @state_on	print_state is overriden with state_on if attached. If Null,
>   *		default method of extcon class is used.
> - * @state_off	print_state is overriden with state_on if dettached. If Null,
> + * @state_off	print_state is overriden with state_on if detached. If Null,
>   *		default method of extcon class is used.
>   *
>   * Note that in order for state_on or state_off to be valid, both state_on
> -- 
> 1.7.9.5
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
