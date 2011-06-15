Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1FOSs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:48:58 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:55294 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752899Ab1FOSs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:48:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tTEfue813lMj+gzdx+9mVsd+TDrl+uzlDiLUlnb8Tg1gOvjiLeJEg8DgsebULppEG+YzMVsjGeK0XwOGVAMDjt58MraqMsjpaPE9YE15KZOivOUE+8fV3uJRpjuYyZQB;
Date: Wed, 15 Jun 2011 11:48:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "rocko" <rockorequin@hotmail.com>
Subject: Re: [Bug #36332] Intel gpu turns external monitor off when X starts
Message-ID: <20110615114849.2e7a1174@jbarnes-desktop>
In-Reply-To: <kTLfM29CaqB.A.lDF.8zS9NB@chimera>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
	<kTLfM29CaqB.A.lDF.8zS9NB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011 23:12:10 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36332
> Subject		: Intel gpu turns external monitor off when X starts
> Submitter	: rocko <rockorequin@hotmail.com>
> Date		: 2011-05-31 02:53 (13 days old)

Possibly more DPMS confusion; Chris what's the latest on that?

rocko, did you ever bisect this to a particular commit (sounds like
between .38 and .39)?

-- 
Jesse Barnes, Intel Open Source Technology Center
