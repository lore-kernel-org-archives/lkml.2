Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab2EYQcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:32:03 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63632 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab2EYQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:31:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAEFj984efuO12nSPsZ2A0Q0nwPLesYJ8gDHwgh=0e1VO3_UtGw@mail.gmail.com>
References: <1337934071-29342-1-git-send-email-qasimj@gmail.com>
	<CAEFj985HxSrOwOoevDjG1jxPxobLda-X_LZUtj6LgwXZwozBog@mail.gmail.com>
	<CAJivULpmLp9JK+PQZ9RkrvvYHNk=uA33=A-ffftroigivy1_NQ@mail.gmail.com>
	<CAEFj984efuO12nSPsZ2A0Q0nwPLesYJ8gDHwgh=0e1VO3_UtGw@mail.gmail.com>
Date: Sat, 26 May 2012 00:31:57 +0800
Message-ID: <CAEFj987dNMyMcS9rySzVpfY0Fo5t0LtL9FZg770ohKi+bDO9ZA@mail.gmail.com>
Subject: Re: [RFC] mac80211: Use correct originator sequence number in a Path Reply
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: devel@lists.open80211s.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ravip@utdallas.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that the PREQ element has originator sequence number at the
> end but the PREQ element has the target sequence number at the end.
> This is what mesh_path_sel_frame_tx is doing.

PREP element has originator sequence number at the end but the PREQ
element has the target sequence number at the end.

Regards,
Chun-Yeow
