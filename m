Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab2EYRRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:17:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42256 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2EYRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:17:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAEFj987dNMyMcS9rySzVpfY0Fo5t0LtL9FZg770ohKi+bDO9ZA@mail.gmail.com>
References: <1337934071-29342-1-git-send-email-qasimj@gmail.com>
	<CAEFj985HxSrOwOoevDjG1jxPxobLda-X_LZUtj6LgwXZwozBog@mail.gmail.com>
	<CAJivULpmLp9JK+PQZ9RkrvvYHNk=uA33=A-ffftroigivy1_NQ@mail.gmail.com>
	<CAEFj984efuO12nSPsZ2A0Q0nwPLesYJ8gDHwgh=0e1VO3_UtGw@mail.gmail.com>
	<CAEFj987dNMyMcS9rySzVpfY0Fo5t0LtL9FZg770ohKi+bDO9ZA@mail.gmail.com>
Date: Fri, 25 May 2012 12:17:34 -0500
Message-ID: <CAJivULpT=XTG2tKm=hQk9mHwJ2K5eo_siHRAWfL0y3vPfrRLiA@mail.gmail.com>
Subject: Re: [RFC] mac80211: Use correct originator sequence number in a Path Reply
From: Qasim Javed <qasimj@gmail.com>
To: Javier Cardona <javier@cozybit.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ravip@utdallas.edu,
        devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to add Javier. Could you please comment on this?

Thanks,
-Qasim

On Fri, May 25, 2012 at 11:31 AM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> I think that the PREQ element has originator sequence number at the
>> end but the PREQ element has the target sequence number at the end.
>> This is what mesh_path_sel_frame_tx is doing.
>
> PREP element has originator sequence number at the end but the PREQ
> element has the target sequence number at the end.
>
> Regards,
> Chun-Yeow
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
