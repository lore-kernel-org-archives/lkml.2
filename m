Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0IKQ4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 12:56:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59228 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0IKQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 12:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=BdUeW5bk05vVToYTM22/1YnUUAyy6mE0nOWroe1s1WF+anRRVQOV61IHJPZVJEfqmK
         B91xbHKbhVEnv4YQ9CKM9y0mnYPf/9cLAiz3xHsgo6aRU0z3R/WevwYy6AhJThjXpxE8
         kxKX278XEPOdQHz2B17DV0+6TbKqmFi9Yf2R8=
Message-ID: <4C8BB4F3.3040907@gmail.com>
Date: Sat, 11 Sep 2010 09:57:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: git crapps out with {kernel_version}/usr/include
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

finishing up with looking at broken web addresses Im noticing that
usr/include/* seems to not work with git i.e. theres a couple of broken 
addresses in there after changing them, then using git commit -s -a
gives me the "nothing to commit message"..
why is this?

Justin P. Mattock
