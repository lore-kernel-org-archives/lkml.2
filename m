Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0JAWin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 18:38:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35444 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab0JAWim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 18:38:42 -0400
Message-ID: <4CA662E2.4040509@zytor.com>
Date: Fri, 01 Oct 2010 15:38:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "stable@kernel.org" <stable@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Please promote to stable
References: <4CA64CC1.5050702@zytor.com> <20101001221615.GA12589@kroah.com>
In-Reply-To: <20101001221615.GA12589@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 03:16 PM, Greg KH wrote:
> On Fri, Oct 01, 2010 at 02:04:01PM -0700, H. Peter Anvin wrote:
>> Please promote the following x86 patches to stable:
>>
>> 1dedefd1a066a795a87afca9c0236e1a94de9bf6
>> d900329e20f4476db6461752accebcf7935a8055 [as soon as Linus merges it]
>>
>> The latter is already tagged stable.
>>
>> These two patches are needed to resolve kernel bugzilla 16322.
> 
> For .35 and .32, or only .35?
> 

Both.

	-hpa
