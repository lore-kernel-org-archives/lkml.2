Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab0FRUSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:18:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47671 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab0FRUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Yx+RqgOHkbxRu2uaNHaLftxy1TON8e/XwIfApCEoRERN/PE4qhLj8esGBWZlhfv0vu
         4JuJFxOHaK7gjUtcuK1azqX7/uLlZOE95s1TXQhGIms4J3mjv0Nb+T0EvLHhui7+zDEx
         QzvzmmAb3eh7eEGcCk2pqU2Q1Mbuo+u6cb93U=
Message-ID: <4C1BD477.2070308@gmail.com>
Date: Fri, 18 Jun 2010 13:17:59 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/5]scsi:hosts.c Fix warning: variable 'rval' set but
 not used
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	 <1276666434-11227-6-git-send-email-justinmattock@gmail.com>	 <1276702443.2847.153.camel@mulgrave.site>  <4C18F524.4000902@gmail.com>	 <1276709590.2847.176.camel@mulgrave.site>  <4C1A4A69.7060801@gmail.com> <1276889827.2850.331.camel@mulgrave.site>
In-Reply-To: <1276889827.2850.331.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the help, and info on this..I just tested and sent out the 
patch let me know if it's legit or not..

Justin P. Mattock
