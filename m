Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2IGTLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:11:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2IGTLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:11:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 05/31] arm64: MMU initialisation
Date: Fri, 7 Sep 2012 19:10:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-6-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-6-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071910.57084.arnd@arndb.de>
X-Provags-ID: V02:K0:WjSgz5nuzJR/b8awdqy0fjbmpF6GlXzc9klLayY5nqX
 aKzVqcXra3VT0gY23IeF8LTjvllBh1bJkfM+0OIRLtu1jAWJ92
 WPqHmQlFu85ogt1ZycRL07Gkj4TUCWmVmcA/h1Y6Rk4wq/tLqK
 2+T+7YS/r1c2uJaXQFpKH/BUruqlvqcsqqoDELe2uUAEQUFXNl
 lZSQIY34DOnA7l4O66UzZFHE6lWGpJwP/dV0BHe2syNcdV4PoW
 4upSYP1LooHxVvOLbz8NgmW6TvCOXz/f02YYSJPP/gFgT5GHJp
 QrhtABFLmCtS1GJh63lciFenW3o6eWRPikf4KpQgVavcHffNYr
 z+b0gJHMYq+TBkcQcRp0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> 
> This patch contains the initialisation of the memory blocks, MMU
> attributes and the memory map. Only five memory types are defined:
> Device nGnRnE (equivalent to Strongly Ordered), Device nGnRE (classic
> Device memory), Device GRE, Normal Non-cacheable and Normal Cacheable.
> Cache policies are supported via the memory attributes register
> (MAIR_EL1) and only affect the Normal Cacheable mappings.
> 
> This patch also adds the SPARSEMEM_VMEMMAP initialisation.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
