Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab0LOA1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:27:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44026 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab0LOA1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:27:13 -0500
Message-ID: <4D080B53.6060400@zytor.com>
Date: Tue, 14 Dec 2010 16:26:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Jack Steiner <steiner@sgi.com>, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
References: <20101214220932.GA1206@sgi.com> <4D07F6A2.2030706@zytor.com> <alpine.LFD.2.00.1012141819580.25387@x980>
In-Reply-To: <alpine.LFD.2.00.1012141819580.25387@x980>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 03:22 PM, Len Brown wrote:
> 
>> Why just x86-64?
> 
> the patch applies to all x86, 32 and 64-bit.

Then please state so in your comments.

	-hpa

