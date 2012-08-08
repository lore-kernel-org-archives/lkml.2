Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2HHCI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 22:08:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14248 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2HHCI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 22:08:56 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-9a-5021ca3649ed
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Dongjin Kim'" <Dongjin.Kim@agreeyamobility.net>
Cc: "'Dongjin Kim'" <tobetter@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1344366398-19022-1-git-send-email-dongjin.kim@agreeyamobility.net>
 <201208071938.26507.arnd@arndb.de>
 <A6A3B7488C419F488E5B13FFD03C08AD2F4372EB@SN2PRD0510MB370.namprd05.prod.outlook.com>
 <201208072029.08693.arnd@arndb.de>
In-reply-to: <201208072029.08693.arnd@arndb.de>
Subject: =?ks_c_5601-1987?B?UkU6IMi4vcU6IFtQQVRDSCAyLzRdIGFybS9kdHM6IGV4eQ==?=
	=?ks_c_5601-1987?B?bm9zNDogQWRkIERUUyBmaWxlcyBkZXJpdmVkIGZyb20gYw==?=
	=?ks_c_5601-1987?B?b21tb24gRXh5bm9zNA==?=
Date: Wed, 08 Aug 2012 11:08:54 +0900
Message-id: <0a3a01cd750a$c2e6a2b0$48b3e810$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1021I8x/NFXhXeQqG+bq9k79zD5QALlpgQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAV2zU4oBBovnq1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MtQvXsBas5ay4NPEBYwPjYvYuRk4OCQETiednfrFC2GISF+6t
	Z+ti5OIQEljEKNHxpJcRwpnHJPF9yV1mkCo2AQ2Jw++fgXWLCIRJTFn6B6yIWeAro8SCV5NZ
	ITo+MEq8eXQOrINTQF9iQtMpsLnCAocYJT5tWsYIkmARUJVoenuQpYuRg4NXwFbiZJc3SJhX
	QFDix+R7LCA2s4CBxPtZfawQtrzE5jVvmUHKJQTUJR791YU4wkjidWcrE0SJiMS+F+8YJzAK
	zUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBgfia1g3Flg8Uh
	RgEORiUe3qhkxQAh1sSy4spcoJ84mJVEePccBArxpiRWVqUW5ccXleakFh9ilOZgURLnNfb+
	6i8kkJ5YkpqdmlqQWgSTZeLglGpg5Nmc7hxx8tCZI19/cU+VfvDqJruC9aOJ64+9a7zxpHSV
	kMyhLFFlDbseudjJRZ+EvOT3Pz6sslnmNIu/eZGc1IXH3Qt++d366Vmh7/bhosyVqIheva6J
	OYJ/yqZsnbCv/InZdMfOaxuWf9G+4W6dcn/tqVXant1bk1438vKpWujZZ9ezL3j/W4mlOCPR
	UIu5qDgRAG1DYyZiAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> On Tuesday 07 August 2012, Dongjin Kim wrote:
> > Hi,
> >
> > I didn't use -M and I couldn't see any difference with the it.
> > Did I make something wrong on that patch?
> 
> No, I think it's just git being less smart about file moves than I was
> hoping
> for. It might do the right thing if you do the patch in two steps:
> 
Yeah, in this case, git does not work just as we expected :-(

> 1. rename exynos4210.dtsi to exynos4.dtsi and add a one-line
> exynos4210.dtsi
> file that just includes exynos4.dtsi.
> 
> 2. do all the changes for moving contents back from exynos4.dtsi into
> exynos4210.dtsi and exynos4412.dtsi.
> 
> Not sure if it's worth it though.

Hehehe, but I did with separated commit as per your comment and it was ok,
then squashed, same...uhm...I think, we don't need to keep two commits
here...

> Your version is probably good enough
> if there are no tools to do a better job automatically.
> 
I agree with Arnd's opinion and I will review in detail soon.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

