Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030438Ab2CBS24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 13:28:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46535 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab2CBS2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 13:28:55 -0500
Message-ID: <4F51114D.80704@zytor.com>
Date: Fri, 02 Mar 2012 10:28:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com> <alpine.DEB.2.00.1202281927130.24649@be10.lrz> <4F4D1E6A.5000200@zytor.com> <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com> <4F4E6B98.2090306@zytor.com> <CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com> <4F4EB0B9.2080906@zytor.com> <CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com> <4F4EBF44.60208@zytor.com> <CAKL7Q7qBOe70D80wOqLnnPLQaaVWbb2KB5P5p252oyPS4YgD1Q@mail.gmail.com> <4F4EC19F.4050002@zytor.com> <CAKL7Q7rZyUNNP+jy5ajL2KSbC8S4LEQZWG3vuPVSvSOCd_ZGQg@mail.gmail.com> <CAKL7Q7q9r0mCoGWOFamHUG6ujfs=voyAZBZHChXVO34cjCbZbw@mail.gmail.com> <4F4FE1FA.1040008@zytor.com> <CAKL7Q7owDCs0=RyhY7gLpyYgOJ9gisdH=p2+qvZ043dDFMN76Q@mail.gmail.com>
In-Reply-To: <CAKL7Q7owDCs0=RyhY7gLpyYgOJ9gisdH=p2+qvZ043dDFMN76Q@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 09:53 AM, Joshua C. wrote:
> 
> I thought about your idea for separating the platform specific code in
> another file. It will make the code more modular but at the end we're
> talking about a single function that flips a single bit. I really
> don't see any real benefit from defining it in a separate file. It
> makes (from my point of view) reading the file just more difficult.
> That's why I decided to return the platform specific code back where
> it originally was and only modifiy the x86 code. So I can keep the
> changes at minimum. I'll post the patch later today and cc the tty
> maintainer. Thanks for the help and the ideas.
> 

Yeah, it seems a bit excessive in this case.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

