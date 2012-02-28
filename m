Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965982Ab2B1Sfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:35:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54676 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965107Ab2B1Sfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:35:40 -0500
Message-ID: <4F4D1E6A.5000200@zytor.com>
Date: Tue, 28 Feb 2012 10:35:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: "Joshua C." <joshuacov@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com> <alpine.DEB.2.00.1202281927130.24649@be10.lrz>
In-Reply-To: <alpine.DEB.2.00.1202281927130.24649@be10.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 10:32 AM, Bodo Eggert wrote:
> Asking the BIOS is as correct as querying the memory location (defined
> to have same result), but more expensive.

Not quite, in reality; it is more likely to work on systems which 
implement various kinds of bypass schemes.  The key aspect of this, 
though, is that this is done on a BIOS path and not by groping a memory 
location which may not even be initialized on non-BIOS systems.

	-hpa
