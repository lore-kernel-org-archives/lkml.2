Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab0LNW64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:58:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48059 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0LNW6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:58:54 -0500
Message-ID: <4D07F6A2.2030706@zytor.com>
Date: Tue, 14 Dec 2010 14:58:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: lenb@kernel.org, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
References: <20101214220932.GA1206@sgi.com>
In-Reply-To: <20101214220932.GA1206@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 02:09 PM, Jack Steiner wrote:
> Map ACPI tables as WB on x86_64. No substantive changes to IA64.

Why just x86-64?

	-hpa
