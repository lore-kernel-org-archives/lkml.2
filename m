Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0HWVXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:23:02 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:56357 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0HWVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:23:00 -0400
Message-ID: <4C72E6AF.9060102@pardus.org.tr>
Date: Tue, 24 Aug 2010 00:22:55 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: [PATCH] perf tools: Fix linking errors with --as-needed flag
References: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr> <4C42DFC0.1090708@pardus.org.tr> <20100821172433.GF2973@ghostprotocols.net> <1282459432.11398.53.camel@tropicana> <1282531453.30047.8.camel@tropicana> <20100823143839.GA2761@ghostprotocols.net>
In-Reply-To: <20100823143839.GA2761@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.08.2010 17:38, Arnaldo Carvalho de Melo wrote:
> Em Sun, Aug 22, 2010 at 09:44:13PM -0500, Tom Zanussi escreveu:
>> Looking into it a bit further, both ExtUtils::Embed -e ldopts and
>> python-config --ldflags put the libs at the end, so we should be able to
>> parse the output of those and take only the parts we need for each
>> component.  How about something like this instead?
> 
> Ozan, Kirill, can you please test Tom's patch and see if it fixes the
> problems you noticed so that I can add Tested-by tags and apply this
> patch?

Hi,

I won't be able to test anything for at least 1 week, sorry.

Regards,
