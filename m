Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab1F2Qrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:47:32 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49899 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754842Ab1F2Qr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:47:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OwcklTlCVXP9IX8APEaNhWwnqxhjReofaij4GbeVjMMLDAtX78u3Uf20lklYCSDjK3L0p7uxKXO338m4JqsyxSBKzwKbVomeEmjtWieIiA6S8aLV8o+WWOKLw+DrJ1Tw;
Date: Wed, 29 Jun 2011 09:47:17 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alex Zhavnerchik" <alex.vizor@gmail.com>
Subject: Re: [Bug #36452] Artifacts with 3.0-rc1 on SandyBridge
Message-ID: <20110629094717.10df4637@jbarnes-desktop>
In-Reply-To: <XWjMN7gBoXK.A.bzD.Ia6BOB@chimera>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
	<XWjMN7gBoXK.A.bzD.Ia6BOB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jun 2011 23:23:44 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36452
> Subject		: Artifacts with 3.0-rc1 on SandyBridge
> Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
> Date		: 2011-06-01 13:55 (26 days old)

Is this with integrated or discrete graphics?  Have you tried to bisect
yet?

-- 
Jesse Barnes, Intel Open Source Technology Center
