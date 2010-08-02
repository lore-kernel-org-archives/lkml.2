Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0HBR3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:29:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0HBR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:29:39 -0400
Message-ID: <4C570166.8050105@ontolinux.com>
Date: Mon, 02 Aug 2010 19:33:26 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802063224.GR3948@outflux.net> <alpine.LRH.2.00.1008021639230.32603@tundra.namei.org> <20100802065746.GS3948@outflux.net> <4C569BCA.3050603@ontolinux.com> <20100802163602.GU3948@outflux.net>
In-Reply-To: <20100802163602.GU3948@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:wYUB6fWJnpNDZiRPytiSRyYodT7h3CKNYwj6ON4RfHJ
 b/CQCE74UCCxPjo/Tp9BOdjfIOBvKvtymBFWOvg7QOCK9l2jrl
 aZs4mj1L/waTKDllpbZgbcaQyJ4HZpMyx7Ss18jK0gXZ4O2jpy
 enk90OXj+7MCNKV1b85KnTEqkm6FT6qEvkSb5exFintOwjwPVq
 mEPepqgBEHx0rJIljc+Gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees;
On the 02.08.2010 18:36, Kees Cook wrote:
> Hi Christian,
>
> On Mon, Aug 02, 2010 at 12:19:54PM +0200, Christian Stroetmann wrote:
>    
>> But we discussed as well that the problem of chaining of small or
>> large LSMs is not an argument for the existence of the Yama LSM, and
>> that the LSM architecture should be developed further so that all of
>> the functionalities of other securtiy packages without an LSM can be
>> integrated as a whole by a new version of the LSM system in the
>> future and not by ripping them of like it was done with the Yama LSM
>> [3].
>> You can see these objections [3] as a second NAK, but now from a
>> company's developer (I haven't said this before, because I'm not a
>> hard core kernel developer).
>>      
> I'm not sure I understand you, exactly. Are you saying that Yama should not
> exist because it might grow into a large LSM?
>
> -Kees
>
>    

Sorry, but: No, you haven't. In fact we have these lines of discussion:
1. You said "Trying to chain comprehensive LSMs seems like it will 
always fail, but putting little LSMs in front of big LSMs seems like an 
easy win." And I said that "I don't think that the problem is if an LSM 
is small or large."
2a. I said also "[...] you will put more and more functionalities, maybe 
again taken from other packages, into your new LSM with the result that 
at the end it will be a big LSM. And then?". Then after point 1. we have 
a chaining problem of comprehensive LSMs, as you said.
2b. Otherwise, if we have no chaining problem as I said (see point 1.) 
and your LSM becomes larger, then I said it is better to solve the 
problem at the side of the LSM architecture and not be ripping off other 
security packages and put their functionalities into LSMs like it was 
done by the Yama LSM.

So that doesn't mean that the Yama LSM should not exist because it might 
grow. It means: If the Yama LMS grows mainly by porting into it 
functionalities of other security packages that actually have no 
relation to the LSM system, then it should not exist in favor of a new 
LSM architecture that enables the integration of those security 
packages. The Yama LSM should not become a container of functionalities 
of other already existing security packages. If you put only your own 
security concepts and methodes into it, then its OK, for sure.
Also, the Yama LSM should not exist if it only dictates the structure of 
the other LSMs, especially if it becomes large and in this way important 
to be followed by only growing it with functionalities taken from other 
security packages. If you say that the way of the Yama LSM is the right 
way to do it in general, then we don't need a new LSM like Yama, but a 
new LSM architecture.

Hopefully I could clearify it now a little bit better. Otherwise the 
night is long :)

Best regards
Christian Stroetmann
