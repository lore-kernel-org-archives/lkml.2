Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab0HKKMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 06:12:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42378 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab0HKKMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 06:12:03 -0400
MIME-Version: 1.0
In-Reply-To: <4C624AE1.30504@st.com>
References: <4C5F9B25.8080401@st.com>
	<AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com>
	<4C624AE1.30504@st.com>
Date: Wed, 11 Aug 2010 11:11:57 +0100
Message-ID: <AANLkTi=SnPm7H75C7ycUH-GzENEDKWtncvLqeEVoEMQm@mail.gmail.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
From: Valeo de Vries <valeo@valeo.co.cc>
To: viresh kumar <viresh.kumar@st.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 August 2010 08:01, viresh kumar <viresh.kumar@st.com> wrote:
> On 8/11/2010 3:34 AM, Felipe Contreras wrote:
>> On Mon, Aug 9, 2010 at 9:07 AM, viresh kumar <viresh.kumar@st.com> wrote:
>>> > Mail server in ST has recently changed and now we have Microsoft
>>> > exchange server. We are using thunderbird as mail client.
>>> > What we observed with this server is that patch are broken now while
>>> > sending as well as receiving. Tabs are replaced by spaces and may
>>> > be some other too which we haven't observed.
>>> >
>>> > Has anybody found a solution to this kind of issues? Are there any
>>> > workarounds possible?
>> Same in Nokia. I wrote a script to fix exchange's crap, but I also
>> noticed some quoted-printable mails didn't get converted, so the
>> easiest would be to tell git to always send quoted-printable.
>>
>
> Hi Guys
>
> The situation has changed now.
> We are informed that SP2 is already in place in ST and mail client is not
> doing any tampering.
>
> When i send a mail using git send-email then it receives fine on
> outlook but on thunderbird, tabs are converted to spaces.
>
> This doesn't happen with every patch on thunderbird, but only a few.
> And observation is that it happens only with big patches.
> (more than 500 lines)
>
> Any idea, how to solve issue now on thunderbird??

You might be in luck:

  * Choose View – Toolbars to ensure that the formatting toolbar is visible,
  then at the left of the formatting toolbar change Body Text to Preformat.
  (lifted straight from Google)

HTH,
Valeo
