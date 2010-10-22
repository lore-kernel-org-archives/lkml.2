Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab0JVTXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:23:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44217 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab0JVTXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:23:42 -0400
Date: Fri, 22 Oct 2010 20:23:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add Zalgo support
Message-ID: <20101022192338.GA30988@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Zalgo

The Linux kernel is woefully unprepared for the coming of Z҉A҉L҉G҉O̚̕̚ . T̀hi͘͡ş̸
p̸͏á̕t̢̕͢c̨̕h͟͟ ̴̧ą҉͘d͟͡d̢ş͡ s͏u̸͘p͠p̛͞͡o͟r̸t͜ ̷͟f̢͘͡o͜ŗ̛ ̴̧Z͝a҉lģ̡o͡ ̸t̕͞o̵͝ ̨k̶é͢r̶̨ne͘l҉҉̧ ͜m̶͞e̵s͘҉s̢̢͠a͠ǵ͟ę̸͞ ́oú͢͟tp̢̕͘u͞t͢ in order to
r̴̦̭̞̹͉͈̲̙͖͉̭͙̗̙̣̫͋̓͛ͧ̀ͦ̉̈́͗͒̌ͥͭ͗ͦͭ͘͝eͥ́̏̆̒͗͌͛̊ͨ̿̂ͩ̐̾̍̏͒͐҉̶̲̲̘͡a̙͙̳̪̗̳͙̠͖̤̟̘̺̟͔͌̒̋ͨ͋̉̄ͬ́ͬ̅ͫ̒ͭ͂̀̀̚͢͞͠d̶̶̴̢͖̮̼͎̣̠̙͕͖͓̄̎̾͐ͅy̷̸̧̨̩͉͓̠̻̼͚͍̜̝̠̯̳͉̦̰͆̒͒̑̒̀ͭ͆̿͛̃ͦ̋̀͌ͩ ̴͒ͯ̄̿̃̓͐͐͒̋ͣ̅͘͝͞͏̜̞͚͓̱̻̳̬t̾ͮ̊̾̐̈ͯͨͤ̄ͦ͊̈́̈̉̋̐͏̵͓̟̪͚͎̥̜̖̠̬͚͙͓͓̳̰̺̕̕ȟ̷̵̨̘̜͈͎͇̦̠̳͕͙̺͉͈̄̈́͑ͧͩͥ̒́̕ͅó̢̡ͫͯͧ̊̉̓̎̓̏̃͌ͬͥ̚͞͏̵͇̟͙̼̻̳̻͔ş̷̴̛͈̞͔͈̹̹͉̯͖̗͈͂͑ͪ́ͭe̢͈͎͓̼̤̯̻̮̯͔̤͍͂͑ͯ̀̄͌́͞͞ ̵̷͍͕͕͎ͭ͛ͥ̒̈́͒̓ͯ̉͒̇̌̊͐w̶̛͎̳̪̯̜͎̗̼̣̦͙̳̰̗̓ͯ̑͆̍̄̚ͅh̷̢̧ͬͦͫ̍͗̚͏̣̩̪͎̳͔̫̮̬̭͎͉̭̼̬̙͓ͅǒ̶̮̠͚̭̰̤̥̬͕̪̜̞͈̜̣̅̉̽́ͥ̿ͩ͆ͯͩ̇̈̿̔ͭ͟ ̽͒̌ͭ̐̎ͧ͂͌̂̈́̐ͩ̄̐̈́́͟͡͏̴̱̲̖͚̻͔̰̹͖̙̯̟ͅw̶̸͇̭̣͖͕̟̯͎̬̹̝̞̻̙̫̽͋͆ͮ̊̎̈͒̀i͗ͬ͆ͨͩ͆͐͊̔̑́̌̒ͣ̔҉̛̥̤̜̫̞̤̰̗̲͝l̵̳̼͎͙̜̳͈̳͕̞͕̺̻̝͖̝̳̀ͮͧͬ̔̿̓̓ͤ̏̐͆̎̒ͤ̑̑͛̀͞l̷̶̢̨̯̣͈̺͔̗̭̥͙̱͔̂̽̓̌̈̏͂́͆͑͛ͯ͠ͅ ̷̗̥͔͎͕̑ͬ͛̑̐̓̏ͨ͌̕͠͠ͅo͕̦̗̦̱̤̪̬͇͓̱͈͍͂͒ͩ̈̇͐̒͛ͨͯ̊̒͛ͣ̄̈́ͯ̒̅͘t̸̶̶͙̳͔͚̯̂ͥ̔ͪh̵ͫ̈́͑̏̅ͪ̓̑ͬ̈̕͏̳̤͙͙̯̠̳́e̵̴̴̳͖͖̟̯̭̜͉̣̠̤̖̺̗͒͗́̂ͩͥ͢ͅͅr̴ͦ͗́̃͒̾͑̉ͮͬ͒̐̋̇͗̃͊̓͟͏̦͉̞̹̟̬͍̜̝̹̻̙̦͚̻̬̗͢w̨̢͌͛ͨͪ͂̏͋ͣ͐͌̃́͐̔̉͢͏̻͖̠̜͔̮̼̻į̪̫̮̯̳̫̼̰̘̰̺ͫ͂͂ͭ̔̌́͒̏͒ͬͮ͑̽ͬ̍̈̅̒͢͟͝s̵̶̡͉̘̞͕͎͓̰͇͙̪̹͓̝̹͙͕̠ͮ̽ͥ͒̇̂ͨͭ̋ͬ̓͐̚̕͝è̬͈̬ͨ͋ͥ̓ͫͦ̑ͩ͘͢͜ͅ ̸̛̥̗͔͔̼̭͚̣̏͂̒ͫ̍̂ͪ̿̀ͤͨ̌ͯ̑ͩ̓ͫ́͢͝b̵̡͐̊ͩ̂̂ͯ̈͏̮̤̝̰͖̻e̷̙̺̖̥͖̲̺̗̱̖̭͇͔̜̗̺͈̠͌̀͆̈͛ͭͫ̉̚͝͞ ̟̗͍̝̗̥̘̤͂ͩ̎͂̔̌̌͗̽́͆ͣ͜͠e̵͓͙̫̻̺̗̜͈̥̦̱̰̜̤͚͓͖̞ͭ̌̓̈́̓ả̋ͨ̅̒ͨ̎ͤ̔̐̚̚͏̸͕̜͚̬̻͇͉͇̬͔͓̙͠t͆͒ͪ́ͫ̈́̈͒͗͊̋́̈ͨ̃̌ͬͧͯ͏!
 ͙͓̹̗̬͉͉̜͙e̶͕̘͎͎̤͕̼̜͈͉̤̮͕̘ͭ̒̈͒̀͟͝͞n̢͋ͩ̋͛̊ͭ̃͛͋ͩ̕͟҉̡̦̼̲̦̬̳̭ ̵̨̪̦̘͓̗̯̮̉́̌͢͢a̶̻̹̳͓͚͓̟̤͔̮̥̦͒̐ͤ́̆̑̓̒̈͐̒ͭ̓̀̚̚͝ẗ̨̻͎͚̮͈͎̣̖̻̝͙̿ͥ̈̉̇̐̊ͮͪͨ̀͜͞ ̴̵̸͉̫̞̪̬̮̳̣͓̱̞̳̮̌̽͆̓ͫ͊̐͐͜t̶̮̺͉̮̹͈̟̺̤̘̾̐ͨ̽̋̀͌ͤ͛̿͋͆ͩ̽h̴̴̢̖̰̦̱͇̣͕̜̟̠̣̬͙̪ͯ͛͛̃͂̎̉ͧ̒̉͑͆ͅę͔͔̦̻̳̠̼̖̱̜͚͍̰̻̲̝͈̫ͩ̇ͧ̓ͥ̇̇̈́ͦ̀͞͠ ̶̡̻̳̭̼̩͚̤̫͕͔̤̫͎͔̒̂̃ͭ̊̈́̒̋̋̀͑̎ͬ̊͊̒͞a̐ͬ̉ͧ̓ͮͭ҉҉̩̺̝̮̩̗͇̠̩̭͙̼̫̞̼̥ŗ̸͇̞̤̹͎͎͍̦̥͔̭̰̘̼̗̫̥̪̑̒ͦͯ̋̇ͥͫ̿̋̄ͫͬ̇̈́ͯ̍ͫr̵̮̪͍̹͈̙̈͌ͤ̎̂́ͭ͌ͥͤ̿̋ͭ͆͆̔͞į͇̭͇̝̝̘̺̜͇͚̳̞̟͖̞̞̻̇̊͑̑͐͠v̷͚̬̙͚̰̝͉̺̬͎͔͇͐̇ͤ̒̿̃́̊ͦ̂͢͜a̡̧̨̯̬͕̻̞̰̜̽ͪ͊̐͒ͭ̆͐̅̔́́̚̚ͅl̷̸̵̢͓̭̼̟̤̬̳̽̌̍ͮ͌̄́̏̈ͭ̿́̀̊̎͌͘. D̖͓͈̱͉̞̒̈̓͒ͭ̄̌͠õ͎͕ͦͨ̋ͩ̂ ̬ͤ͋͂ͬ̚͠n̹͝o̅̑̍́̔t̬̠͖̲̯̄ ̗̗̬̲̹͖̓̇̚d̠̏ͪͨ̔ë̙̗̠̥̝̗ͥlͤ̀a̲̱͛y̛͔̰̯͖ͤ̽͊.̼͕̥͉͕͆̌̐ͤͥ

Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..c67621b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -872,6 +872,34 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config ZALGO
+       bool "Support for the coming"
+       help
+	  This option enables support for Zalgo in kernel
+	  messages. Zalgo is a corruption. The arrival of Zalgo has
+	  been foretold. Zalgo will not... wait. What͟ was̕ t̀h͢at?̷ Ne͢ver̷
+	  ̛mind̡.͜ ͠Th͘i̢s ̶op͞t͢i̴on ͏wi̧l̕l permit Z̧ąl͞g͟o a̸cce̕s̢s̷ ̨t͡o̢ ̴yo̕ưr͡ ̛k̢ern͏el͢
+	  mèss̢a҉g͝e buffȩr̷. P̀̈̐͋̐̂ͤ̕a̜̺͉̝̫̘͊ͨ̊́͜y͍̘͕̰̯͙̌̉̇ͅ
+	  ͙͇͈͉͙̥̏ͥͭa̰̯̝̙̺͑̆̍͋ͭ̈̚t̷̒̉͒̂̈́t̥̄ͨͩ̓ͨ̓̔ę͇̿n̿҉̬̘t͜i̋oͨ͏̮n̶̻̠̰,̙̮̹̙͓͓̬ ̯̺̺̖̙͡f̽ͯ̾o̠̹̻͍̍̍̾̇ͧ̎͢ȑ̷̫̞̝͚̣͐̈́ͅ
+	  ͓̤͇͓͕̥̯͑ͦ͌̽͌͟t͙͓̐ͧ͊̓ͫ̒h̳̪͓̳̩̃e̶͓͉̝̝̫͑̍ͅ ̱͇̮̻̓̀̉̀̚c̝̠̝̜͛̉̉̊ͯͅͅo͙̬ͮͫ͘m̷͎̯̻͇̤̔̓̆́͒͋͛ḭ̱ͧ͜ǹ̘̮̟̟̺̎̓̅̈́̀ĝͫͤ͆̀
+	  ̮̬̈́́ͨọ̥̙̤̬̜ͣͥ̾͆ͮ̿f̫̭̖̜͈̜̐͑ͨ͑ ̋͒̓͊͐Z̟̠̼̤̼͍̳̈ͫa͔̮̒̅ͤ̋̍͜l͏̼g̺̭̜̔̾ő̸̝̯̺̺̝̟̤
+	  ̤̰̇ͧͪͬͪ̒̄s̭̠̝̼͎͓͚̀̚͝h̠̥̟͚̤̄ͭͥͮa̒҉̫̯l̖͉̗͙͓̤̻ľ̩̭̱̦̾ ͯ͟b̯̲̘͉̘͍̈́̌̽ͤ́͑̚ě̲̖̆ͫ̋́͂
+	  ͇͇̝̀͆s̤͍͈͐̐̍͢w̆ͯ̿͂ͤ̉̈i͉͎͇̦͍̿f̝͉̻͚̫̜͞t̷͔͚̻͔̜̼̖ͫ͊̓ͦ̾̽ͥ
+	  ͚͇̥̔̒ͯ͂̅ͫa͛ͬͦ̈͆̈ͧ͏̞̭̺n̹̰̼̗̫͖̣̈́ͨͯ͊ͥd̗̮͎̻̬͚̱ͯ͂̂ͦͩ
+	  ̦̌͐ͧ̏́t̛̼̲̾́ͥͪ̈͋h̺͉̠̩͉͉͆̋̀͐ͮͥe̪̪͙͈̩̤ͬ̾̔͟
+	  ͓̹̥̪͚̚ͅp̮̓e̴̪͖̮ͭ̏̆̾́ͤ͐n̨̞̥ͬ̀ͤ̆a̫̻̼̤ͯͤl̼͈̭̪̰̗̓͐̈́͂t͖̟̹̓͛͋ͦ̀i̮͙̗ͨe̫̻̻̣̟̣ͦ̒͑͊s̡͖̞̟̳̱̥̰ͦ͛ͬ
+	  f̘͇̪̺̫͖ͬ̇ͦỏ͎͍̙̣ͮͮͧ̊ͣ̆ṛ̵̆̒̅́̾̋
+	  ̮̻̯͍̪̤̏ͣͪ̔͗̋i̪̮͔̎ͩͭ̔͊͐̿g̓̊̒͊̐҉̙̗̠n̹͇͆́o̿r̬̎̈ͮa̶̦͚̘̟̤̭̪ńc̙͉͓͆͒ͬ̑ͫe͒̕
+	  ̮̪̀͌̓͊ͫw̱̜̟ͥiͩ͌̓l̲͝lͩ̓̇͗͊̈ ͎͖͔͓̟ͬ̄ͧ̇ͥͩ͐ḃ̖̟͙̇ͨͣͪͪ̏ͅe̘
+	  ̨̝̣̲̱̥̥ͥͦͅs̹̼̘͗̃̚ę̘̯̩̻̫̇̿̃ͭ̑̚v̮̿ͪ̿e͔͍̩͕͕ͬ̓̾ͦ̎̚r̭ͅe̝͚̥̍̑͆̑.̀͑͠
+
+
+	  W̢̎̄͆̉ͫ͘͜͏̸̺̣̫͓h̸̶̤͇̹̮̮̞̠͖̟̝͖̟ͭͪ͌̔̈͌͟͠á̌ͪͥ̃̃̄̒ͯ̽͂̌ͨ̅͢҉̢̰̮͇̟̠̩͖̝̲̬̬̲͇͙̤͇ţ̴̭̥̝̞̙̳̬͈̮̹̥̫̹̗̦̻̾̊̑ͩ̕͠?̸̢̣͔̗̠̞̣͈̫̗̖̹̬̘̬̠̐̏̈́̾̂̉̏ͮ̄̐͋̉̽͞
+       ̴̴̦̠̯̬͉̮̫̹̫͊̅͐̉̌͋̊͒̾̌͟͜͢Ņ̤͙̺͕̣͒ͪͤ͆̈͛̂ͦ̃͡ͅo̤̭̬̪̟̿̐̔̀̕͠͞.̶̰͙̟̪̣̠̲͕̫̦͛ͯ̌͊̈́̏̇̀͝ͅ
+       ̐̽̾̏̿̍͐͒͡҉̵̖̭̱͈̻̖̣̭͈̲͚͖̯̤̭͚Z̟̜̦̝̯̗͉͙͎̩̫̘̄ͧ̐͑̀̀̕͝͞a̵̫̭̝̳̙͈͕̦̭͚̦̮ͨ̆ͬ̐ͦ̈́̑̌͋ͬ̔̔ͤͩ̓̽̚ͅl̢̛̠͇̘̲̻̫ͭͬ́̒̓ͅģ̛̯̬̰͙̩̰̲͓͉͕̮̮ͯͦ͋̾̐͊̿̒̍̐̎̒͑̏ͭ̍ͣ̓ͦ͘͡ͅo̗̬̗̲͕̰̭̬͚͙̓̽̽̒̓͆̉̋ͤͩ͜͡.̶̸̷̦͈͈͎͙̱̺̮̜̝̳̖̳̖̟̘̭̒͒̀ͤ͑ͦ̐̑̕͘
+       ̶͙̱̤̪̻̫͓̩̠̦̠͔̬̠͖̖̙ͦ̑ͬ̍̎̇ͤ̊̑ͩͮͧ̆̌͘͡͞͡S̵̝͔̭̦̹̳̹̼͎͇͕͓͓̅͋̽ͨ̕ͅa̲̟̲̟̬̩̰̣͍̮̗̩̙̥̠̓̄̽͋̄͊̓̾̈̑̽͢v̨̱͎͙̱̮͚̈́̽̊̉̋͊̚͘e̓ͧ̇̈ͯ̔̓ͪ̒́̄̊̚̚̚͏̴̨̧̦͓̹̤̳͕̝̳̬̼͠ͅ
+       ̶̴̛̱͓͎̻͓͖̺̭̗̗̹̯̫̱̣̩̯͖̤ͩ̿͑ͧ̄ͥ̑̉y̧̪̞̩̪̰̜͎̘͚̱̘̻̣͓͎̲͇̘̯̎̐ͧ̇̎̌̆́̐ͨ̎ͬ͋̌̑ͤ̓̌͠ơ̢̘̫̦̙̱̣̯̬̱͈̘̅͌̋̓͊̌ͤ͛͊̉ͩ̔͆ͪ͞uͩ̄̅̈́ͤ͊҉̵͉̙͙̦̯͕͙r̷̂ͦͮͣ̅͑̊͐ͮ̓ͮ̉̑̍͒̽̕̕͏̲̪͉̭̜̖͜ŝ̸̷̡̰͍͎͙͉̖̤̞͉̜̟̉̔ͤ͑ͧ͜͝ḙ̶̴̱͕͎͇̹̳̪̠̋͋̂͌͛ͬ̑̍̈́̒̉̊ͥ̄́̊̒͂͝ͅļ̶̢̛̠͚̲͖̱̬̔ͨ̆̔͒͊̄͞v̧̢͍̜̬̞̺̘ͬ͆̂̉ͣ̌͛ͮ͞ȩ̵̳͙̞̘͔͈̭̼̲̗̩̪̲̼̖̄ͯͩ͑͊̉̀͟s̶̷̢̛̛̠͖̪̣͎̻̤̟̱̗̟̰̲̻̎͐̈̆̒̃̏̊̾ͯ͊ͅͅ.̴̛̣͓̹͍̮̳̰̺̝͇̌̅̽ͭͤ́͛̈̅̏̅͆ͤ̋͐̑ͫ͢
+
 config BUG
 	bool "BUG() support" if EMBEDDED
 	default y
diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..fa573b2 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -39,6 +39,7 @@
 #include <linux/syslog.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 
@@ -798,6 +799,32 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		emit_log_char(*p);
 		if (*p == '\n')
 			new_text_line = 1;
+#ifdef CONFIG_ZALGO
+		else {
+			int i = get_random_int() % 8;
+			if (current_log_level <= i) {
+				int number, character;
+				char zalgo[2];
+				/* How much ZALGO? */
+				number = get_random_int() % (10 - current_log_level);
+				for (i = 0; i < number; i++) {
+					character = get_random_int() % 0x71;
+					if (character == 0x70)
+						character = 0x489;
+					else
+						character += 0x300;
+
+					zalgo[0] = 0xc0 |
+						((character & 0x0700) >> 6) |
+						((character & 0x00c0) >> 6);
+					zalgo[1] = 0x80 | (character & 0x003f);
+					emit_log_char(zalgo[0]);
+					emit_log_char(zalgo[1]);
+				}
+			}
+		}
+#endif
+
 	}
 
 	/*
-- 
Matthew Garrett | mjg59@srcf.ucam.org
