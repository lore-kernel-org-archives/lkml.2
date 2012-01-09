Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2AIO4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:56:20 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:21724 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754079Ab2AIO4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:56:19 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XgrkChcVM1nF1pYoVYjT2dtRvwXSWpxg651aS70cFnekJcm
 .C2rMia5KPe8Kf7roIVuXnqOB5llQ8Uff0k59I31l3ViKUjIwEYYeBB9OE_u
 XUaJVq45NzEmxP6v4uR0.TgboRLb13evlD.IVy_4ajI4Pz2BMs0eKm3XEbLN
 jgw.yp7zOORKJio9_Om51zbQ9FPet9lMT8Jb76dtdYQAC4cbnQyaovPt2c3k
 6b1JE_7jn9Hfc3v6xtM.IRRNhYCsPcEzZVLhn46D2EBfuixVOViyTprqPH0.
 o4.YvZy1EnQf4xviqfDT2KifAJw58SkUm6zry_j7xx87l8Gmvk1YOmRAjPox
 GxxQg0kGvzyu6R8Su6_lsoLThRHuDCholk61TmN4E5u6tKJKw_PdRnDcGQOd
 X8CkyvYtwGNMI8NbwDzS8
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 9 Jan 2012 08:56:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Switch per cpu partial page support off for debugging
In-Reply-To: <1326020041.32105.3.camel@jaguar>
Message-ID: <alpine.DEB.2.00.1201090855530.29109@router.home>
References: <alpine.DEB.2.00.1111230923260.16544@router.home>  <alpine.LFD.2.02.1112120915030.2555@tux.localdomain>  <alpine.DEB.2.00.1112141908410.27595@chino.kir.corp.google.com>  <alpine.DEB.2.00.1201060934550.10460@chino.kir.corp.google.com>
 <1326020041.32105.3.camel@jaguar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jan 2012, Pekka Enberg wrote:

> I think I applied the patch before your comments. EINVAL sounds
> reasonable to me. Christoph?

Sounds all fine to me. Hope I get around to it this week.

