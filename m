Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0FIU0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:26:33 -0400
Received: from fep14.mx.upcmail.net ([62.179.121.34]:64983 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0FIU0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:26:32 -0400
X-SourceIP: 77.57.188.152
Message-ID: <4C0FF8F2.5070104@odi.ch>
Date: Wed, 09 Jun 2010 22:26:26 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100415 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: freeze when strace X
References: <4C0FDF9F.9070000@odi.ch> <20100609195228.GA27088@srcf.ucam.org> <4C0FF34D.6090800@odi.ch> <20100609200610.GA27536@srcf.ucam.org>
In-Reply-To: <20100609200610.GA27536@srcf.ucam.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=tsaDvxd5BMYuajhtvJLL+Ppe47iaIgCGP4JcOtoQkcg= c=1 sm=0 a=zNANCjgXmV0A:10 a=8nJEP1OIZ-IA:10 a=ENdvOZnJ4qRVE2Fq6LIA:9 a=AKybijNsLi0pg3IiO9fRLZ6Qk6AA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09.06.2010 22:06, Matthew Garrett wrote:
> strace needs to output text via X, which generates output which needs to 
> be output via X... and you'll tend to deadlock. If X is holding any 
> interesting kernel locks at that point then it wouldn't surprise me if 
> the machine ends up dead.

Alright. It *is* a silly thing to do. Sorry.

