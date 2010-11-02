Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0KBMre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:47:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45915 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0KBMra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZJpmxlptjp4uLHeC2lQ4fRHfN50SIdB0nz0HgggY8xtUXG5xKl2YlauG5KPNnG6oHO
         gJNjeL0T848sNlqAmPthJtkJ3GsvKv3uDa0QMyTFVvLbKPe3t8g+lD+Fc4DDhLZBuhHR
         js+QDcc6G8wWT/T++7DGCRr1c0EP65gtHcNu0=
MIME-Version: 1.0
In-Reply-To: <AANLkTim0oHFehpJggt9c8PhSZpOZZA1Qz=h6rC5NjeCY@mail.gmail.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
	<AANLkTim0oHFehpJggt9c8PhSZpOZZA1Qz=h6rC5NjeCY@mail.gmail.com>
Date: Tue, 2 Nov 2010 21:47:28 +0900
Message-ID: <AANLkTimmDUc7pigVysJn1T-Dt4sFKGFpw_EuBAEuxu6T@mail.gmail.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Ben Gamari <bgamari.foss@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/2 Minchan Kim <minchan.kim@gmail.com>:

> Apparently, it wouldn't hurt maintain the kernel. But I have a concern.
> As someone think this parameter is very important and would be better
> to control by kernel config rather than init script to make the
> package, it would make new potential kernel configs by someone in
> future.
> But I can't convince my opinion myself. Because if there will be lots
> of kernel config for tuning parameters, could it hurt
> maintain/usability? I can't say "Yes" strongly. so I am not against
> this idea strongly.
> Hmm,,  Just pass the decision to others.
>

please modify sysctl setting....

No ack from me.

Thanks,
-Kame
