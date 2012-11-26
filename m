Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab2KZX0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:26:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29495 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab2KZX0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:26:43 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-02-50b3fab14714
Message-id: <50B3FAAB.9090406@samsung.com>
Date: Tue, 27 Nov 2012 08:26:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Only set GPIO if it has been requested
References: <1353929315-8874-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1353929315-8874-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zPd2NvzYHGDybp2xxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyjq4+ylbwh73i48V3zA2Mt9m6GDk5JARMJFa13maEsMUkLtxb
	DxTn4hASWMYoMe3BPnaYogO3ZjJDJKYzSpz+/4IVwulikpg2B6KKV0BL4sbNs2A2i4CqxJOz
	d8BWsAHF97+4AWRzcIgKREj86ueAKBeU+DH5HgtIWARowe/7lSAjmQUWM0r82fMA7CJhAR+J
	fW/ngo0UEgiRmDjvMQuIzSkQKvH182cwm1lAR2J/6zQ2CFteYvOat8wQJwhIfJt8CGy+hICs
	xKYDYPdLCDSzS/z+18gE8ZikxMEVN1gmMIrNQnLSLCRjZyEZu4CReRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGSExI7WBc2WBxiFGAg1GJh1dh3eYAIdbEsuLK3EOMEhzMSiK8v7YDhXhT
	EiurUovy44tKc1KLDzH6AF07kVlKNDkfGK95JfGGxgbGhoaWhmamlqYGOISVxHmbPVIChATS
	E0tSs1NTC1KLYMYxcXBKNTAKzlsyq/7jex2dSMtvQou2KRbIKjuFWAUt3nCQ75fYzMn1Pezs
	9nmbN96U/bXqwPUDMTlW1+W8fSuvmchH3fJhepO92qdDT/W43Nf9K79z33M6vOmC0u7yK98O
	MR/RjCmxjanMj5/zclvntKdMzBbrHAIb/N/rSE6Nib1xS/L8h5ANnbf/64UosRRnJBpqMRcV
	JwIACi/d7LYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd2NvzYHGLRclrG4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGUdXH2Ur+MNe8fHiO+YG
	xttsXYycHBICJhIHbs1khrDFJC7cWw8U5+IQEpjOKHH6/wtWCKeLSWLanH3sIFW8AloSN26e
	BbNZBFQlnpy9AzaJDSi+/8UNIJuDQ1QgQuJXPwdEuaDEj8n3WEDCIkDLft+vBBnJLLCYUeLP
	ngeMIDXCAj4S+97OBRspJBAiMXHeYxYQm1MgVOLr589gNrOAjsT+1mlsELa8xOY1b5knMArM
	QrJiFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjrhnUjsYVzZYHGIU4GBU
	4uFVWLc5QIg1say4MvcQowQHs5II76/tQCHelMTKqtSi/Pii0pzU4kOMPsAAmMgsJZqcD0wG
	eSXxhsYmZkaWRmbGJubGxjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUw6nA+OZIpd6Zd
	982Nb2XFvlxsF/31mCs6b4smKEsU3CuzfNG64jbTkYZPet+iZO9WsNmczr3qlKfcteL28R+/
	v5a31HUcesx/gLVN7HRqVCYfY1VGt65pxGnX8jeaDMVCG05NzVnYEH6odI140dwDm298/jWj
	MbF2+YqFN5cdOOAsJhr4/6a+EktxRqKhFnNRcSIADHGV5OUCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 08:28 PM, Mark Brown wrote:
> The micd_pol GPIO is only requested if we've specified one greater than 0
> so apply the same test before we set it.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index cdab9e5..585882e 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -85,8 +85,9 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
>  {
>  	struct arizona *arizona = info->arizona;
>  
> -	gpio_set_value_cansleep(arizona->pdata.micd_pol_gpio,
> -				info->micd_modes[mode].gpio);
> +	if (arizona->pdata.micd_pol_gpio > 0)
> +		gpio_set_value_cansleep(arizona->pdata.micd_pol_gpio,
> +					info->micd_modes[mode].gpio);

Why not use gpio_is_valid() function to test arizona->pdata.micd_pol_gpio ?
