Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2CAAYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:24:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34514 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab2CAAYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:24:09 -0500
Message-ID: <4F4EC19F.4050002@zytor.com>
Date: Wed, 29 Feb 2012 16:23:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com> <alpine.DEB.2.00.1202281927130.24649@be10.lrz> <4F4D1E6A.5000200@zytor.com> <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com> <4F4E6B98.2090306@zytor.com> <CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com> <4F4EB0B9.2080906@zytor.com> <CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com> <4F4EBF44.60208@zytor.com> <CAKL7Q7qBOe70D80wOqLnnPLQaaVWbb2KB5P5p252oyPS4YgD1Q@mail.gmail.com>
In-Reply-To: <CAKL7Q7qBOe70D80wOqLnnPLQaaVWbb2KB5P5p252oyPS4YgD1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 04:21 PM, Joshua C. wrote:
>
> Thanks for the help. You can better figure out where this code should
> go into. Can you prepare the patch for merging in the mainline kernel?
>

Yes, although "when" would be a very open question.

I realize it is frustrating to do these kinds of things for the first 
time and getting what feels like a lot of very picky feedback.  The hope 
is that the learning experience makes the second, and third, and fourth 
time a lot less painful.

	-hpa
