Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1FMGog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 02:44:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35875 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1FMGob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 02:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=sG/B2KZUj7pPgA1MjPESg2TtYzUeo9l+BWwejaF/DwKb/qqYD0LZCXrP7T7wNo7YR9
         lnIAtIYfHKQiexh3ZT2G57XPV59135BrOM2z7EyYVtUWlGqAOTF8ip3CUimDmQR+Top0
         oNgAFoVu4k7Fw4DDhlveLw+QrwN5o/9N0uPCs=
MIME-Version: 1.0
Reply-To: d.g.jansen@googlemail.com
In-Reply-To: <kTLfM29CaqB.A.tBF.6zS9NB@chimera>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera> <kTLfM29CaqB.A.tBF.6zS9NB@chimera>
From: Dennis Jansen <Dennis.Jansen@web.de>
Date: Mon, 13 Jun 2011 08:43:50 +0200
X-Google-Sender-Auth: m1agFa8JF3kjsA7dWGn2sufBUCA
Message-ID: <BANLkTi=j3ZXtsVitZFW=hgspKr2XQe4ysw@mail.gmail.com>
Subject: Re: [Bug #36392] 2.6.39, 3.0-rc2 Intel DRI Regression: Black Screen
 after trying to play video
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 11:12 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).

Yes it should. And there's nobody actively working on it yet it seems.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=36392
> Subject         : 2.6.39, 3.0-rc2 Intel DRI Regression: Black Screen after trying to play video
> Submitter       : Dennis Jansen <dennis.jansen@web.de>
> Date            : 2011-06-01 04:41 (12 days old)
>
