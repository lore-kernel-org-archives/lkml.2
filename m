Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab1FJTJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:09:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57847 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab1FJTJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uWUtHmHyaDQBcO+gS0QhpkxIcCE4noaJy/Z7luTu3oOkCA1fpfT6hGr7r6lGJ26SRp
         DkozWAu8CxWTLXE+wRiM+gqEcClf3mp/q0+VtAkTRhZQiUAVF1+pCHB7+8Zq6XJhS76L
         wCvEkJMg5+rk/7H6jj2vPI1YlTZQ7DCXuXpsU=
MIME-Version: 1.0
In-Reply-To: <20110610094242.GC1621@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
	<4df13c362729376e2@agluck-desktop.sc.intel.com>
	<20110610094242.GC1621@aftab>
Date: Fri, 10 Jun 2011 12:09:38 -0700
Message-ID: <BANLkTim4=h6TzbhTQVi0OAQLk+WGQnDFOw@mail.gmail.com>
Subject: Re: [PATCH 05/10] MCE: Mask out address mask bits below address granuality
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 2:42 AM, Borislav Petkov <bp@amd64.org> wrote:
> s/granuality/granularity/g;
>
> I would very much like to know how you guys got 'granularity' wrong
> _three_ times in one small patch?!!

Speshial skiil, tallent, and reguler speelling praktice sesssions :-)

[At least we spelled it wrong the same way each time]

Will fix.

-Tony
