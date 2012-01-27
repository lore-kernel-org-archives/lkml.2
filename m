Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2A0Tig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:38:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab2A0Tie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:38:34 -0500
Message-ID: <4F22FD36.6020309@canonical.com>
Date: Fri, 27 Jan 2012 11:38:30 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Kees Cook <kees@ubuntu.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] AppArmor: refactor securityfs to use structures
References: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
In-Reply-To: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 04:29 PM, Kees Cook wrote:
> This is the ground-work for expanding the AppArmor securityfs to include
> useful information that the userspace tools can more easily interact with.
> Presently, this is only static information about the state of AppArmor.
> 
James,

if no one else has issues with these, I will pull these patches into the
apparmor tree to batch them together as pull request with some other
apparmor patches
