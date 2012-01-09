Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2AIVcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:32:18 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:29309 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2AIVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:32:17 -0500
X-Authority-Analysis: v=2.0 cv=JJy5Qr2b c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=8nJEP1OIZ-IA:10 a=h07iDeEFhKFip9vjwasA:9 a=wPNLvfGTeEIA:10 a=pkiy876LBrpJhbxj:21 a=TQP-17Tf4yB6CwQE:21 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F0B5CDE.8000700@cfl.rr.com>
Date: Mon, 09 Jan 2012 16:32:14 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Multiple consoles
References: <4F0B5808.2010900@cfl.rr.com> <20120109212125.GO4266@type.famille.thibault.fr>
In-Reply-To: <20120109212125.GO4266@type.famille.thibault.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2012 4:21 PM, Samuel Thibault wrote:
> Phillip Susi, le Mon 09 Jan 2012 16:11:36 -0500, a écrit :
>> Does this make sense or am I missing something?
>
> It used to be planned, but nobody took the job, because X doesn't need
> this (see option -sharevts).

If you do that, you can't use vcs.  AFAICS, there won't be any on the 
second seat, and if you switch the first seat back to a vc, it will read 
input from both keyboards.  And what about magic-sysrq?  A SAK on either 
keyboard will kill the primary X won't it?
