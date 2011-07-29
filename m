Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1G2ODF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:03:05 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34464 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1G2ODD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <4E32BB6F.3090607@broadcom.com>
References: <8d47115a01b74b768ea4850fb314b16d-mfwitten@gmail.com>
 <768a3afa74c244e8b43a376dd4fb0df4-mfwitten@gmail.com> <4E32BB6F.3090607@broadcom.com>
From: Michael Witten <mfwitten@gmail.com>
Date: Fri, 29 Jul 2011 14:02:32 +0000
Message-ID: <CAMOZ1Bt3BkNeVONXu_0xoAxx=tUFLryaaW9XtPt6AxhJmTF9GA@mail.gmail.com>
Subject: Re: [PATCH 1/4] Docs: Typo: coordinate{,s}
To: Arend van Spriel <arend@broadcom.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 13:53, Arend van Spriel <arend@broadcom.com> wrote:
> On 07/29/2011 02:46 PM, Michael Witten wrote:
>>
>> Signed-off-by: Michael Witten<mfwitten@gmail.com>
>> ---
>>  include/linux/cordic.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/cordic.h b/include/linux/cordic.h
>> index f932093..de741da 100644
>> --- a/include/linux/cordic.h
>> +++ b/include/linux/cordic.h
>> @@ -35,8 +35,8 @@ struct cordic_iq {
>>   * @theta: angle in degrees for which i/q coordinate is to be calculated.
>>   * @coord: function output parameter holding the i/q coordinate.
>>   *
>> - * The function calculates the i/q coordinate for a given angle using
>> - * cordic algorithm. The coordinate consists of a real (i) and an
>> + * The function calculates the i/q coordinates for a given angle using
>> + * cordic algorithm. The coordinates consist of a real (i) and an
>>   * imaginary (q) part. The real part is essentially the cosine of the
>>   * angle and the imaginary part is the sine of the angle. The returned
>>   * values are scaled by 2^16 for precision. The range for theta is
>
> Most patches in this series are fine by me. However, the function takes a
> single angle as input and returns a single two-dimensional coordinate as
> output. The coordinate itself is represented by the two axis i and q. So I
> tend to say changing coordinate to coordinates is not justified here.
> However, I not a native english speaker so I may be wrong here.

Sure.

Jiri, I'll send you a pull request later with the update(s).
