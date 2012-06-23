Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2FWLSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 07:18:38 -0400
Received: from shiva144.upmc.fr ([134.157.0.144]:62203 "EHLO shiva.upmc.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753430Ab2FWLSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 07:18:37 -0400
X-Ids: 144
X-CIds: courriel3
Message-ID: <4FE5A5FB.3080608@upmc.fr>
Date: Sat, 23 Jun 2012 13:18:19 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120318 Thunderbird/11.0
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        linux-nfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rpc_pipefs kernel panic kernel 3.4.3
References: <F77FADB4-0415-4945-AC03-CEE36F2FEB08@upmc.fr> <4FE4DB31.4000601@free.fr> <4FE4F7FA.4000604@free.fr> <20120623061353.GA18625@electric-eye.fr.zoreil.com>
In-Reply-To: <20120623061353.GA18625@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I confirm that 3.3.8 is fine.
NULL pointer seems to have been introduced in 3.4 rpc_pipefs if I am right.

Bernard

