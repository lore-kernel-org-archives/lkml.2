Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab2DISGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:06:24 -0400
Received: from server1.neighborhoods.net ([207.154.13.48]:52645 "EHLO
	server1.neighborhoods.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab2DISGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:06:21 -0400
Message-ID: <4F832519.5040805@meetinghouse.net>
Date: Mon, 09 Apr 2012 14:06:17 -0400
From: Miles Fidelman <mfidelman@meetinghouse.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        peter.chubb@nicta.com.au, michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
References: <4F8302B4.8040901@meetinghouse.net> <20120409155155.GA22974@srcf.ucam.org> <4F831BD0.3010707@meetinghouse.net> <20120409173223.GA25717@srcf.ucam.org> <4F83231A.8040005@meetinghouse.net> <4F832370.8040508@zytor.com>
In-Reply-To: <4F832370.8040508@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 04/09/2012 10:57 AM, Miles Fidelman wrote:
>> No.  2.6.32.5  (the one that currently ships with Debian stable).
>>
> 2.6.32.*5*?!??

Ooops.. my mistake - suckered by the Debian package nomenclature.
uname -a returns: 2.6.32-5-xen-amd64
upstream seems to be 2.6.32.41



-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra


