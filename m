Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2GTI2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:28:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58423 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2GTI2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:28:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
Date: Fri, 20 Jul 2012 08:28:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Christopher Covington <cov@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <5008445B.2010109@codeaurora.org> <5009044E.9060908@jonmasters.org>
In-Reply-To: <5009044E.9060908@jonmasters.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201207200828.13128.arnd@arndb.de>
X-Provags-ID: V02:K0:dnHKJx1+CGVYaY9+XmI9wOgomHVj/Dmk20RVICqzl6j
 XyQ1jqREj9RSiribbQOZNgYLYlRHVsO3BNoOSrJQsruEnAnH4g
 QopMSgpxt427UMpVwEJaPRFCHC8XW/15QjvTQLa/+PZwyGJTS3
 5TMVf2ng0GLc3pPAEbLTOwHeIGtfBh2kNk9JITYKs4t8OCxGHS
 EFZpkdT3ma7XaO2RzL3+vcyxUSzLBkTWflx/nF9Pxsp8WjSZ9E
 u9v2gg4ZMkad2qn1/2bBOXxW2uM+nQilYmGfUC1yJNeFQ2sMoc
 wa89Wy9SujEkVhPlMLwM49WCa+zd373wR1GMX9bHtOkbbFZ2Ra
 9dH7wNUuAxlUJxWxZcpk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012, Jon Masters wrote:
> > I think it would be best to list the technical limitations, from the
> > kernel's perspective, of the unsupported exception levels and the
> > advantages of the supported exception levels here. If you want to guide
> > system builders towards EL2, I think it'd be more convincing to document
> > the relevant technical aspects (perhaps KVM needs facilities only
> > available in EL2) than just providing an unexplained requirement.
> 
> Unless you enter at EL2 you can never install a hypervisor. That's the
> reason for the requirement for generally entering at EL2 when possible.

How do nested hypervisors work in this scenario? Does the first-level
hypervisor (counting from most priviledged) provide a guest that starts
in an emulated EL2 state, or is this done differently?

	Arnd
