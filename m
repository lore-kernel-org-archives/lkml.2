Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab0HIOe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:34:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45000 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab0HIOe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100809141906.GA31487@riccoc20.at.omicron.at>
References: <4C5F9B25.8080401@st.com>
	<20100809141906.GA31487@riccoc20.at.omicron.at>
Date: Mon, 9 Aug 2010 15:34:23 +0100
Message-ID: <AANLkTi=xyTVpoJimU69DrcUeJ783tQKDf9vBMDBtAcES@mail.gmail.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
From: Valeo de Vries <valeo@valeo.co.cc>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 August 2010 15:19, Richard Cochran <richardcochran@gmail.com> wrote:
> On Mon, Aug 09, 2010 at 11:37:33AM +0530, viresh kumar wrote:
>>
>> Has anybody found a solution to this kind of issues? Are there any
>> workarounds possible?
>
> I have this same problem. The exchange server rewrites incoming and
> outgoing plain text emails as it sees fit, and our IT department seems
> unable to turn this "feature" off.
>
> One work around is to get an gmail account and use IMAP.

The other solution is to kindly request that one's IS department
upgrades Exchange so that this particular issue (of converting tabs to
spaces) won't be a  problem any longer... ;)

You're right though, it's probably easier just to use another provider
for e-mail, as this isn't the only way Exchange will mess with
patches.

Valeo
