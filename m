Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab1FVNT7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 22 Jun 2011 09:19:59 -0400
Received: from [141.85.37.183] ([141.85.37.183]:42270 "EHLO mail.ceata.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1FVNT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:19:58 -0400
X-Greylist: delayed 1224 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jun 2011 09:19:58 EDT
To: <linux-kernel@vger.kernel.org>
Subject: Maximum number of inotify watches
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Jun 2011 15:59:20 +0300
From: "Tiberiu C. Turbureanu" <tct@ceata.org>
Organization: Ceata
Message-ID: <bbaaf72bb3386008c77db2e16112b330@ceata.org>
User-Agent: RoundCube Webmail/0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello,

 I want to monitor all the files on a server using one instance of 
 inotify and about 20M watches recursively set on directories in '/' tree 
 substructure. I'd want to be notified about all type of events defined 
 by inotify (create, delete, access, modify etc.)

 Assuming this monitor daemon running in user-space keeps up with the 
 frequency of new events in the kernel queue (it reads them), is it 
 possible to exceed the kernel memory limit because there are too many 
 watches and events?

 TIA,
 Tibi
