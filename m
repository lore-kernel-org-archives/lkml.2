Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0ISUXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 16:23:21 -0400
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:41651 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab0ISUXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 16:23:19 -0400
Message-ID: <4C967131.8030802@uni-koeln.de>
Date: Sun, 19 Sep 2010 22:23:13 +0200
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Software error at bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To whom it may concern:

I'm getting an error at https://bugzilla.kernel.org.

Software error:

The ./data/params file does not exist. You probably need to run 
checksetup.pl. at Bugzilla/Config.pm line 333.
Compilation failed in require at /var/www/bugzilla/show_bug.cgi line 27.
BEGIN failed--compilation aborted at /var/www/bugzilla/show_bug.cgi line 27.

For help, please send mail to the webmaster (root@localhost), giving 
this error message and the time and date of the error.


Regards,
Berthold Cogel
