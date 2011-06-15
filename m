Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1FOGBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 02:01:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55613 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1FOGBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 02:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qQK9mixzfq+rf+Yh78jURXW0gA8oSIcoW4LNtrfHgAFBgAGNGzybu6W1DykHpsrqrF
         LG+9lXR1uR/OLYJBpjkUHN1AQKfSp4HiTyHhuKaQM+67ChIYt0JDeBGBkLT/oIer3TYw
         iFhnxv4aKw8+Oma2aPdSL+nV1rdNh+qMd+44c=
MIME-Version: 1.0
In-Reply-To: <20110614221517.GA20319@dev1756.snc6.facebook.com>
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
	<20110609193300.GA16858@dev1756.snc6.facebook.com>
	<20110614221517.GA20319@dev1756.snc6.facebook.com>
Date: Wed, 15 Jun 2011 14:01:31 +0800
Message-ID: <BANLkTikcxA53t1ummUG3-3TagFhj==qYjw@mail.gmail.com>
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
From: Sam Liao <phyomh@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 6:15 AM, Arun Sharma <asharma@fb.com> wrote:
> Sam,
>
> $ perf report -g graph,0.5,caller --sort pid
>
> is a bit hard to type. Perhaps add a simpler command line option
> that has the same effect?
>
>  -Arun
>
>

How about perf report -g [caller/callee,][graph,0.1] -s pid

or remove the order of the options for "-g"

-Sam
