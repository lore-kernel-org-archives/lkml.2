Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2ISLpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:45:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2ISLpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:45:19 -0400
Date: Wed, 19 Sep 2012 13:45:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 6/7 v2] HID: picoLCD: drop version check during probe
In-Reply-To: <20120917202108.3e39dedb@neptune.home>
Message-ID: <alpine.LNX.2.00.1209191344500.31149@pobox.suse.cz>
References: <20120730213656.0a9f6d30@neptune.home> <20120730213859.063173c1@neptune.home> <alpine.LNX.2.00.1208151015220.7026@pobox.suse.cz> <20120819185631.3a984aa4@neptune.home> <20120917202108.3e39dedb@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Bruno Prémont wrote:

> You seem not to have applied this one yet (it doesn't show up in picolcd
> branch).
> 
> Could you please apply it?
> (or did I miss locking changes making it obsolete?)

No, sorry, I lost that one. Applied now.

Have you and David made any progress with the locking?

-- 
Jiri Kosina
SUSE Labs
